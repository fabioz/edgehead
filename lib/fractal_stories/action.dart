library stranded.action;

import 'package:edgehead/ecs/pubsub.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/history/action_history.dart';
import 'package:edgehead/fractal_stories/item.dart';
import 'package:edgehead/fractal_stories/room_approach.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:meta/meta.dart';

import 'actor.dart';
import 'plan_consequence.dart';
import 'simulation.dart';
import 'storyline/storyline.dart';

/// A generic type for builder functions that take a parameter to build
/// a concrete implementation of an action.
///
/// For example, a "kick-someone" builder can take an Actor Joe as [parameter]
/// and can output "kick Joe" action.
typedef T ActionBuilder<T extends Action, V>(V parameter);

/// A typedef for [Action]'s apply functions: both [Action.applySuccess] and
/// [Action.applyFailure].
typedef String ApplyFunction(ActionContext context);

abstract class Action {
  String _description;

  /// The command that describes this action.
  ///
  /// For example: "open the door" or "swing at the orc".
  String get command;

  String get helpMessage;

  /// Whether or not this action is aggressive towards its sufferer. Combat
  /// moves are aggressive, healing moves aren't.
  ///
  /// This describes intent, not result. A failed attempt to kill someone is
  /// aggressive although it doesn't harm the intended target.
  bool get isAggressive;

  /// Returns `true` for actions that shouldn't be presented to the player
  /// because they are the only thing that _can_ be done in a situation.
  ///
  /// It is a runtime error when there is more than one action valid at a time
  /// and one of them is implicit.
  ///
  /// Returns `false` for ordinary actions.
  bool get isImplicit;

  /// Returns `false` if this action is a reaction to someone else's action.
  /// Returns `true` if the actor chose this action pro-actively.
  ///
  /// Examples of reactive actions are 'dodge' and 'parry'. Examples of
  /// proactive actions are 'slash' and 'cast spell'.
  bool get isProactive;

  /// The name of the class of the Action.
  ///
  /// We need to use this instead of the [runtimeType] because [runtimeType]
  /// can be mangled in production (dart2js).
  String get name;

  /// Whether or not the actor can exert a resource (of type [rerollResource])
  /// to reroll a failed throw.
  ///
  /// For example, the player can exert his spare [Resource.stamina] to reroll
  /// an attempt to parry an enemy's attack. This will give him another throw,
  /// but will also decrease his stamina. We need to know which type of stat
  /// this action takes.
  bool get rerollable;

  /// When [rerollable] is `true`, this field must be set to the type of
  /// resource that can be exerted.
  ///
  /// The resource must be spent _outside_ [apply]. The game system – not
  /// the class – is responsible for taking the resource away and reporting
  /// on it.
  Resource get rerollResource;

  Iterable<PlanConsequence> apply(Actor actor, PlanConsequence current,
      Simulation sim, WorldState world, PubSub pubsub) sync* {
    var successChance = getSuccessChance(actor, sim, current.world);
    assert(successChance != null);
    assert(successChance >= 0.0);
    assert(successChance <= 1.0);

    if (successChance > 0) {
      final worldOutput = world.toBuilder();
      Storyline storyline = _applyToWorldCopy(
          actor, sim, worldOutput, applySuccess, pubsub,
          isSuccess: true);

      yield new PlanConsequence(
          worldOutput.build(), current, this, storyline, successChance,
          isSuccess: true);
    }
    if (successChance < 1) {
      final worldOutput = world.toBuilder();
      Storyline storyline = _applyToWorldCopy(
          actor, sim, worldOutput, applyFailure, pubsub,
          isFailure: true);

      yield new PlanConsequence(
          worldOutput.build(), current, this, storyline, 1 - successChance,
          isFailure: true);
    }
  }

  /// Called to get the result of failure to do this action. Returns
  /// the mutated [Simulation].
  String applyFailure(ActionContext context);

  /// Called to get the result of success of doing this action. Returns
  /// the mutated [Simulation].
  String applySuccess(ActionContext context);

  /// Returns a string that will explain why actor needs to roll for success.
  ///
  /// For example:
  ///
  /// * "Will you hit him?"
  /// * "Will you dodge the swing?"
  String getRollReason(Actor a, Simulation sim, WorldState w);

  /// Success chance of the action given the actor and the state of the world.
  num getSuccessChance(Actor a, Simulation sim, WorldState w);

  bool isApplicable(Actor a, Simulation sim, WorldState w);

  void _addWorldRecord(ActionRecordBuilder builder, WorldStateBuilder world) {
    if (_description == null) {
      throw new StateError("No description given when executing $this. You "
          "should return it from your world-modifying function.");
    }
    builder.description = _description;
    builder.time = world.time;
    world.recordAction(builder.build());
  }

  Storyline _applyToWorldCopy(Actor actor, Simulation sim,
      WorldStateBuilder output, ApplyFunction applyFunction, PubSub pubsub,
      {bool isSuccess: false, bool isFailure: false}) {
    final initialWorld = output.build();
    final builder =
        _prepareWorldRecord(actor, sim, initialWorld, isSuccess, isFailure);
    final outputStoryline = new Storyline();
    // Remember situation as it can be changed during applySuccess.
    final situationId = initialWorld.currentSituation.id;
    initialWorld.currentSituation
        .onBeforeAction(sim, initialWorld, outputStoryline);
    final context = new ActionContext(
        this, actor, sim, initialWorld, pubsub, output, outputStoryline);
    _description = applyFunction(context);

    // The current situation could have been removed by [applyFunction].
    // If not, let's update its time.
    output.elapseSituationTimeIfExists(situationId);

    output.elapseWorldTime();
    output
        .build()
        .getSituationById(situationId)
        ?.onAfterAction(sim, output, outputStoryline);

    // Remove ended situations: the ones that don't return an actor anymore,
    // and the ones that return shouldContinue(world) != true.
    var builtOutput = output.build();
    while (builtOutput.currentSituation?.getCurrentActor(sim, builtOutput) ==
            null ||
        builtOutput.currentSituation?.shouldContinue(sim, builtOutput) !=
            true) {
      // TODO: move the if statement below to the while expression above
      if (builtOutput.currentSituation == null) break;
      output.popSituation(sim);
      builtOutput = output.build();
    }

    // Only 'surviving' (non-popped) situations get to run their `onAfterTurn`
    // methods.
    output.currentSituation?.onAfterTurn(sim, output, outputStoryline);

    _addWorldRecord(builder, output);
    return outputStoryline;
  }

  ActionRecordBuilder _prepareWorldRecord(Actor actor, Simulation sim,
      WorldState world, bool isSuccess, bool isFailure) {
    var builder = new ActionRecordBuilder()
      ..actionName = name
      ..protagonist = actor.id
      ..wasSuccess = isSuccess
      ..wasFailure = isFailure
      ..wasAggressive = isAggressive
      ..wasProactive = isProactive;
    if (this is EnemyTargetAction) {
      final action = this as EnemyTargetAction;
      builder.sufferers.add(action.enemy.id);
    }
    return builder;
  }
}

/// This [Action] requires an [enemy].
///
/// Every [EnemyTargetAction] should contain a static builder like this:
///
///     static EnemyTargetAction builder(Actor enemy) => new Kick(enemy);
abstract class EnemyTargetAction extends Action {
  final Actor enemy;

  @mustCallSuper
  EnemyTargetAction(this.enemy);

  @override
  String get command {
    if (isImplicit) {
      assert(
          commandTemplate == null,
          "When action is implicit, commandTemplate should be null. "
          "Found '$commandTemplate' instead in $this.");
      return "";
    }
    assert(
        commandTemplate != "",
        "Never create actions with empty commandTemplate. "
        "Use isImplicit instead. Culprit: $this");
    return (new Storyline()..add(commandTemplate, object: enemy))
        .realizeAsString();
  }

  /// EnemyTargetAction should include the [enemy] in the [command]. To make it
  /// easier to implement, this class will automatically construct the name
  /// given a [Storyline] template.
  ///
  /// For example, "kill <object>" is a valid name template that might realize
  /// into something like "Kill the orc."
  String get commandTemplate;

  /// By default, [EnemyTargetAction] is not implicit. But it can be.
  @override
  bool get isImplicit => false;

  /// EnemyTargetActions might want to mention the [enemy] in the output
  /// of [getRollReason]. To make this easier to implement, this class will
  /// automatically construct the roll reason given a [Storyline] template.
  ///
  /// For example "will <subject> hit <objectPronoun>?" is a valid roll reason
  /// template that might realize into something like "Will you hit him?"
  String get rollReasonTemplate;

  @override
  String getRollReason(Actor a, Simulation sim, WorldState w) =>
      (new Storyline()
            ..add(rollReasonTemplate,
                subject: a, object: enemy, wholeSentence: true))
          .realizeAsString();

  /// Gets the [Situation.id] of the main situation of this action.
  ///
  /// This is useful for using [Storyline] threads. Actions at the start
  /// of a situation can mark themselves as supportive in a thread, and then
  /// other actions will add themselves to that same thread, so that [Storyline]
  /// can discard the supportive actions when they are to be reported next
  /// to each other. The thread id is taken from the [Situation.id].
  int getThreadId(
          Simulation sim, WorldStateBuilder w, String mainSituationName) =>
      w.getSituationByName<Situation>(mainSituationName).id;

  @override
  String toString() => "EnemyTargetAction<$commandTemplate::"
      "enemy=${enemy.id}/${enemy.name}>";
}

/// This [Action] requires an [approach].
///
/// Every [ApproachAction] should contain a static builder like this:
///
///     static ApproachAction builder(Approach enemy) => new Example(exit);
abstract class ApproachAction extends Action {
  final Approach approach;

  @mustCallSuper
  ApproachAction(this.approach);

  @override
  String get command =>
      approach.command.isNotEmpty ? approach.command : "IMPLICIT EXIT";

  @override
  String toString() => "ApproachAction<$command>";
}

/// This [Action] requires an [item].
///
/// Every [ItemAction] should contain a static builder like this:
///
///     static ItemAction builder(Item enemy) => new Example(item);
abstract class ItemAction extends Action {
  final ItemLike item;

  @override
  final bool isImplicit = false;

  @mustCallSuper
  ItemAction(this.item);

  @override
  String get command =>
      (new Storyline()..add(commandTemplate, object: item)).realizeAsString();

  /// ItemAction should include the [item] in the [command]. To make it
  /// easier to implement, this class will automatically construct the name
  /// given a [Storyline] template.
  String get commandTemplate;

  @override
  String toString() => "ItemAction<$command>";
}

/// This enum defines all the different resources (Stats) that player can use
/// to reroll action throws.
enum Resource {
  /// Using stamina means exerting extra physical energy. Useful for power
  /// moves, running away unscathed, etc.
  stamina,

  /// Some moves can be rerolled by 'spending' balance. A kick will land,
  /// but the player will go off-balance or even fall down.
  balance,

  // TODO: Ideas: weaponGrip (throw sword), shield (let the shield break)
}

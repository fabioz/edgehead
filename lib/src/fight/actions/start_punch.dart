import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/actions/start_defensible_action.dart';
import 'package:edgehead/src/fight/punch/punch_defense/punch_defense_situation.dart';
import 'package:edgehead/src/fight/punch/punch_situation.dart';
import 'package:edgehead/src/predetermined_result.dart';

const String startPunchCommandTemplate = "punch <object>";

const String startPunchHelpMessage =
    "Punching someone hard enough can cause them to lose their footing. "
    "And it hurts.";

EnemyTargetAction startPunchBuilder(Actor enemy) => new StartDefensibleAction(
    "StartPunch",
    startPunchCommandTemplate,
    startPunchHelpMessage,
    startPunchReportStart,
    (a, sim, w, enemy) =>
        !a.isPlayer &&
        (a.isStanding || a.isOffBalance) &&
        !enemy.isOnGround &&
        a.isBarehanded,
    (a, sim, w, enemy) => createPunchSituation(a, enemy),
    (a, sim, w, enemy) =>
        createPunchDefenseSituation(a, enemy, Predetermination.none),
    enemy);

EnemyTargetAction
    startPunchPlayerBuilder(Actor enemy) =>
        new StartDefensibleAction(
            "StartPunchPlayer",
            startPunchCommandTemplate,
            startPunchHelpMessage,
            startPunchReportStart,
            (a, sim, w, enemy) =>
                a.isPlayer &&
                (a.isStanding || a.isOffBalance) &&
                !enemy.isOnGround &&
                a.isBarehanded,
            (a, sim, w, enemy) => createPunchSituation(a, enemy),
            (a, sim, w, enemy) => createPunchDefenseSituation(
                a, enemy, Predetermination.failureGuaranteed),
            enemy,
            successChanceGetter: (a, sim, w, enemy) => 0.8,
            applyStartOfFailure: startPunchReportStart,
            defenseSituationWhenFailed:
                (a, sim, w, enemy) => createPunchDefenseSituation(
                    a, enemy, Predetermination.successGuaranteed),
            rerollable: true,
            rerollResource: Resource.stamina,
            rollReasonTemplate: "will <subject> hit <objectPronoun>?");

void startPunchReportStart(Actor a, Simulation sim, WorldStateBuilder w,
    Storyline s, Actor enemy, Situation mainSituation) {
  s.add("<subject> {thrust<s>|swing<s>} <subject's> fist at <object>",
      subject: a,
      object: enemy,
      actionThread: mainSituation.id,
      isSupportiveActionInThread: true);
}

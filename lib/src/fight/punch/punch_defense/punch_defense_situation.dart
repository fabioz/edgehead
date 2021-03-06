library stranded.fight.punch_defense_situation;

import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/src/fight/common/defense_situation.dart';
import 'package:edgehead/src/fight/punch/punch_defense/actions/dodge_punch.dart';
import 'package:edgehead/src/predetermined_result.dart';

const String punchDefenseSituationName = "PunchDefenseSituation";

Situation createPunchDefenseSituation(
        Actor attacker, Actor target, Predetermination predetermination) =>
    new DefenseSituation.initialized(
        punchDefenseSituationName,
        [
          dodgePunchBuilder,
          // TODO: CutOffArm.builder,
        ],
        attacker,
        target,
        predetermination);

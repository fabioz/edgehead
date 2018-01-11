library edgehead.serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:edgehead/edgehead_global.dart';
import 'package:edgehead/fractal_stories/action_record.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/item.dart';
import 'package:edgehead/fractal_stories/items/weapon.dart';
import 'package:edgehead/fractal_stories/items/weapon_type.dart';
import 'package:edgehead/fractal_stories/pose.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline_pronoun.dart';
import 'package:edgehead/fractal_stories/team.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/break_neck/break_neck_situation.dart';
import 'package:edgehead/src/fight/break_neck/wrestle_defense/wrestle_defense_situation.dart';
import 'package:edgehead/src/fight/counter_attack/counter_attack_situation.dart';
import 'package:edgehead/src/fight/fight_situation.dart';
import 'package:edgehead/src/fight/leap/leap_defense/leap_defense_situation.dart';
import 'package:edgehead/src/fight/leap/leap_situation.dart';
import 'package:edgehead/src/fight/loot/loot_situation.dart';
import 'package:edgehead/src/fight/off_balance_opportunity/off_balance_opportunity_situation.dart';
import 'package:edgehead/src/fight/punch/punch_defense/punch_defense_situation.dart';
import 'package:edgehead/src/fight/punch/punch_situation.dart';
import 'package:edgehead/src/fight/slash/slash_defense/slash_defense_situation.dart';
import 'package:edgehead/src/fight/slash/slash_situation.dart';
import 'package:edgehead/src/fight/strike_down/strike_down_defense/on_ground_defense_situation.dart';
import 'package:edgehead/src/fight/strike_down/strike_down_situation.dart';
import 'package:edgehead/src/predetermined_result.dart';
import 'package:edgehead/src/room_roaming/room_roaming_situation.dart';
import 'package:edgehead/writers_input.dart';

part 'edgehead_serializers.g.dart';

@SerializersFor(const [
  ActionRecord,
  Actor,
  BreakNeckOnGroundSituation,
  CounterAttackSituation,
  EdgeheadGlobalState,
  FightSituation,
  GuardpostAboveChurchTakeShieldRescueSituation,
  Item,
  LeapSituation,
  LeapDefenseSituation,
  LootSituation,
  OffBalanceOpportunitySituation,
  OnGroundDefenseSituation,
  OnGroundWrestleDefenseSituation,
  Pose,
  Predetermination,
  Pronoun,
  PunchDefenseSituation,
  PunchSituation,
  RoomRoamingSituation,
  Situation,
  SlashSituation,
  SlashDefenseSituation,
  StrikeDownSituation,
  Team,
  Weapon,
  WeaponType,
  WorldState,
])
final Serializers serializers = _$serializers;
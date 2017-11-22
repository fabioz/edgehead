library egamebook.command.pick_choice;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'command_base.dart';
import 'package:edgehead/egamebook/elements/choice_element.dart';

part 'pick_choice_command.g.dart';

abstract class PickChoice extends CommandBase
    implements Built<PickChoice, PickChoiceBuilder> {
  static Serializer<PickChoice> get serializer => _$pickChoiceSerializer;

  factory PickChoice([updates(PickChoiceBuilder b)]) = _$PickChoice;

  PickChoice._();

  Choice get choice;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.history;

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

class _$RuleHistory extends RuleHistory {
  @override
  final BuiltMap<int, RuleRecord> records;

  factory _$RuleHistory([void updates(RuleHistoryBuilder b)]) =>
      (new RuleHistoryBuilder()..update(updates)).build();

  _$RuleHistory._({this.records}) : super._() {
    if (records == null) throw new ArgumentError.notNull('records');
  }

  @override
  RuleHistory rebuild(void updates(RuleHistoryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  RuleHistoryBuilder toBuilder() => new RuleHistoryBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! RuleHistory) return false;
    return records == other.records;
  }

  @override
  int get hashCode {
    return $jf($jc(0, records.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RuleHistory')..add('records', records))
        .toString();
  }
}

class RuleHistoryBuilder implements Builder<RuleHistory, RuleHistoryBuilder> {
  _$RuleHistory _$v;

  MapBuilder<int, RuleRecord> _records;
  MapBuilder<int, RuleRecord> get records =>
      _$this._records ??= new MapBuilder<int, RuleRecord>();
  set records(MapBuilder<int, RuleRecord> records) => _$this._records = records;

  RuleHistoryBuilder();

  RuleHistoryBuilder get _$this {
    if (_$v != null) {
      _records = _$v.records?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RuleHistory other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$RuleHistory;
  }

  @override
  void update(void updates(RuleHistoryBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$RuleHistory build() {
    final _$result = _$v ?? new _$RuleHistory._(records: records?.build());
    replace(_$result);
    return _$result;
  }
}

class _$VisitHistory extends VisitHistory {
  @override
  final BuiltListMultimap<int, VisitRecord> records;

  factory _$VisitHistory([void updates(VisitHistoryBuilder b)]) =>
      (new VisitHistoryBuilder()..update(updates)).build();

  _$VisitHistory._({this.records}) : super._() {
    if (records == null) throw new ArgumentError.notNull('records');
  }

  @override
  VisitHistory rebuild(void updates(VisitHistoryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  VisitHistoryBuilder toBuilder() => new VisitHistoryBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! VisitHistory) return false;
    return records == other.records;
  }

  @override
  int get hashCode {
    return $jf($jc(0, records.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('VisitHistory')
          ..add('records', records))
        .toString();
  }
}

class VisitHistoryBuilder
    implements Builder<VisitHistory, VisitHistoryBuilder> {
  _$VisitHistory _$v;

  ListMultimapBuilder<int, VisitRecord> _records;
  ListMultimapBuilder<int, VisitRecord> get records =>
      _$this._records ??= new ListMultimapBuilder<int, VisitRecord>();
  set records(ListMultimapBuilder<int, VisitRecord> records) =>
      _$this._records = records;

  VisitHistoryBuilder();

  VisitHistoryBuilder get _$this {
    if (_$v != null) {
      _records = _$v.records?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VisitHistory other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$VisitHistory;
  }

  @override
  void update(void updates(VisitHistoryBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$VisitHistory build() {
    final _$result = _$v ?? new _$VisitHistory._(records: records?.build());
    replace(_$result);
    return _$result;
  }
}

class _$VisitRecord extends VisitRecord {
  @override
  final int actorId;
  @override
  final String parentRoomName;
  @override
  final String roomName;
  @override
  final DateTime time;

  factory _$VisitRecord([void updates(VisitRecordBuilder b)]) =>
      (new VisitRecordBuilder()..update(updates)).build();

  _$VisitRecord._({this.actorId, this.parentRoomName, this.roomName, this.time})
      : super._() {
    if (actorId == null) throw new ArgumentError.notNull('actorId');
    if (roomName == null) throw new ArgumentError.notNull('roomName');
    if (time == null) throw new ArgumentError.notNull('time');
  }

  @override
  VisitRecord rebuild(void updates(VisitRecordBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  VisitRecordBuilder toBuilder() => new VisitRecordBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! VisitRecord) return false;
    return actorId == other.actorId &&
        parentRoomName == other.parentRoomName &&
        roomName == other.roomName &&
        time == other.time;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, actorId.hashCode), parentRoomName.hashCode),
            roomName.hashCode),
        time.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('VisitRecord')
          ..add('actorId', actorId)
          ..add('parentRoomName', parentRoomName)
          ..add('roomName', roomName)
          ..add('time', time))
        .toString();
  }
}

class VisitRecordBuilder implements Builder<VisitRecord, VisitRecordBuilder> {
  _$VisitRecord _$v;

  int _actorId;
  int get actorId => _$this._actorId;
  set actorId(int actorId) => _$this._actorId = actorId;

  String _parentRoomName;
  String get parentRoomName => _$this._parentRoomName;
  set parentRoomName(String parentRoomName) =>
      _$this._parentRoomName = parentRoomName;

  String _roomName;
  String get roomName => _$this._roomName;
  set roomName(String roomName) => _$this._roomName = roomName;

  DateTime _time;
  DateTime get time => _$this._time;
  set time(DateTime time) => _$this._time = time;

  VisitRecordBuilder();

  VisitRecordBuilder get _$this {
    if (_$v != null) {
      _actorId = _$v.actorId;
      _parentRoomName = _$v.parentRoomName;
      _roomName = _$v.roomName;
      _time = _$v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VisitRecord other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$VisitRecord;
  }

  @override
  void update(void updates(VisitRecordBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$VisitRecord build() {
    final _$result = _$v ??
        new _$VisitRecord._(
            actorId: actorId,
            parentRoomName: parentRoomName,
            roomName: roomName,
            time: time);
    replace(_$result);
    return _$result;
  }
}
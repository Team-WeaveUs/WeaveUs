class WeaveTypeModel {
  final String? weave;
  final String? range;
  final String? invite;

  WeaveTypeModel({
    this.weave,
    this.range,
    this.invite,
  });

  WeaveTypeModel copyWith({
    String? weave,
    String? range,
    String? invite,
  }) {
    return WeaveTypeModel(
      weave: weave ?? this.weave,
      range: range ?? this.range,
      invite: invite ?? this.invite,
    );
  }

  @override
  String toString() =>
      'WeaveTypeModel(weave: $weave, range: $range, invite: $invite)';
}

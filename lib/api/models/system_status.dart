part of api;

@JsonSerializable()
class SystemStatus {
  final int status; // 0: normal，1：system maintenance
  final String msg; // "normal", "system_maintenance"

  const SystemStatus(this.status, this.msg);

  factory SystemStatus.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SystemStatusToJson(this);
}

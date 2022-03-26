part of api;

@freezed
class SystemStatus with _$SystemStatus {
  const factory SystemStatus(
    /// 0: normal，1：system maintenance
    int status,

    /// "normal", "system_maintenance"
    String msg,
  ) = _SystemStatus;

  factory SystemStatus.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusFromJson(json);
}

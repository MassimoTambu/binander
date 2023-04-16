part of api;

@freezed
class RateLimit with _$RateLimit {
  const factory RateLimit(
    RateLimitTypes rateLimitType,
    RateLimitIntervals interval,
    int intervalNum,
    int limit,
  ) = _RateLimit;

  factory RateLimit.fromJson(Map<String, dynamic> json) =>
      _$RateLimitFromJson(json);
}

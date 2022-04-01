part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesPipeLineData implements PipelineData {
  @override
  final OrdersHistory ordersHistory;
  @override
  @JsonKey(ignore: true)
  BotStatus status = const BotStatus(BotPhases.offline, 'offline');
  @override
  @JsonKey(ignore: true)
  Timer? timer;

  @JsonKey(ignore: true)
  AveragePrice? lastAveragePrice;
  OrderNew? lastBuyOrder;
  OrderNew? lastSellOrder;
  int lossSellOrderCounter = 0;

  MinimizeLossesPipeLineData({this.ordersHistory = const OrdersHistory([])});

  factory MinimizeLossesPipeLineData.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesPipeLineDataFromJson(json);

  Map<String, dynamic> toJson() => _$MinimizeLossesPipeLineDataToJson(this);
}

part of minimize_losses_bot;

class MinimizeLossesStrategy implements Strategy {
  @override
  late final String name;

  @override
  late final String publicName;

  @override
  late final String description;

  MinimizeLossesStrategy(this.name, this.publicName, this.description);

  MinimizeLossesStrategy.create() {
    name = 'MinimizeLossesStrategy';
    publicName = 'Minimize losses';
    //TODO desc
    description = '';
  }

  static MinimizeLossesStrategy fromJson(Map<String, dynamic> json) {
    return MinimizeLossesStrategy(
        json['name'], json['publicName'], json['description']);
  }

  static Map<String, dynamic> toJson(MinimizeLossesStrategy strategy) {
    return {
      'name': strategy.name,
      'publicName': strategy.publicName,
      'description': strategy.description
    };
  }
}

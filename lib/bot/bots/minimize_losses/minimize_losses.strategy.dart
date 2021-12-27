part of minimize_losses_bot;

class MinimizeLossesStrategy implements Strategy {
  @override
  late final String name;

  @override
  late final String publicName;

  @override
  late final String description;

  MinimizeLossesStrategy.create() {
    name = 'MinimizeLossesStrategy';
    publicName = 'Minimize losses';
    //TODO desc
    description = '';
  }
}

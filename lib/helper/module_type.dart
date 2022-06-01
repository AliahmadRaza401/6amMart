enum ModuleType {
  food,
  ecommerce,
  grocery,
  pharmacy
}

extension CatExtension on ModuleType {

  String get type {
    switch (this) {
      case ModuleType.food:
        return 'item';
      case ModuleType.ecommerce:
        return 'ecommerce';
      case ModuleType.grocery:
        return 'grocery';
      case ModuleType.pharmacy:
        return 'pharmacy';
      default:
        return null;
    }
  }

}
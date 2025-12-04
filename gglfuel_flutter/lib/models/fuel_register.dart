class FuelRegister {
  final int? id;
  final double fuelQty;
  final double fuelPrice;

  FuelRegister({this.id, required this.fuelQty, required this.fuelPrice});

  Map<String, dynamic> toMap() {
    return {'id': id, 'fuel_qty': fuelQty, 'fuel_price': fuelPrice};
  }

  factory FuelRegister.fromMap(Map<String, dynamic> map) {
    return FuelRegister(
      id: map['id'],
      fuelQty: map['fuel_qty'],
      fuelPrice: map['fuel_price'],
    );
  }

  @override
  String toString() {
    return 'Qtd: $fuelQty L, Preço: R\$ $fuelPrice';
  }
}

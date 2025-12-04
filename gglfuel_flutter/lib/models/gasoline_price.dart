class GasolinePrice {
  final String country;
  final String price;
  final String currency;

  GasolinePrice({
    required this.country,
    required this.price,
    required this.currency,
  });

  factory GasolinePrice.fromJson(Map<String, dynamic> json) {
    return GasolinePrice(
      country: json['country'] ?? '',
      price: json['price'] ?? '',
      currency: json['currency'] ?? '',
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String measurement;
  final double price;
  final String? qrCodeData; // Added to hold QR code data

  ProductModel({
    required this.id,
    required this.name,
    required this.measurement,
    required this.price,
  this.qrCodeData,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      measurement: json['measurement'],
      price: json['price'].toDouble(),
      qrCodeData: json['qrCodeData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'measurement': measurement,
      'price': price,
      'qrCodeData': qrCodeData as String,
    };
  }
}

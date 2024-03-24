part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

/// Event for adding a product.
class AddProduct extends ProductEvent {
  final String name;
  final String measurement;
  final double price;
  final String qrCodeData;
  AddProduct(
      {required this.name,
      required this.measurement,
      required this.price,
      required this.qrCodeData});
}

// Define fetch products event
class FetchProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;

  SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

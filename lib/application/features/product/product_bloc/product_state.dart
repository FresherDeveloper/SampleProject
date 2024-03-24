part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

/// Initial state before any product operation.
class ProductInitial extends ProductState {}

/// State indicating that products are being loaded.
class ProductsLoading extends ProductState {}

/// State indicating that products have been successfully loaded.
class ProductsLoaded extends ProductState {
  final List<ProductModel> products;

  ProductsLoaded({required this.products});
}

/// State indicating that a product operation (e.g., adding) is in progress.
class ProductLoading extends ProductState {}

/// State indicating that a product has been successfully added.
class ProductAddedSuccess extends ProductState {
  final String? qrCodeData;
  final String productId;

  ProductAddedSuccess({required this.qrCodeData, required this.productId});
}

/// State indicating that a product operation (e.g., adding) has failed.
class ProductOperationFailure extends ProductState {
  final String error;

  ProductOperationFailure({required this.error});
}

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:sample_flutter_project/application/features/product/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore firestore;

  ProductBloc({required this.firestore}) : super(ProductInitial()) {
    on<AddProduct>(_addProduct);
    on<FetchProducts>(_fetchProducts);
    on<SearchProducts>(_searchProducts);
  }

  void _addProduct(AddProduct event, Emitter<ProductState> emit) async {
    try {
      emit(ProductsLoading());
      // Add the product to Firestore
      DocumentReference productRef =
          await firestore.collection('products').add({
        'name': event.name,
        'measurement': event.measurement,
        'price': event.price,
        'qrCodeData': event.name
      });

      // Generate QR code based on product name
      String qrCodeData = event.name
          .toString(); // You can customize this data as per your requirement

      emit(ProductAddedSuccess(
          qrCodeData: qrCodeData, productId: productRef.id));
    } catch (error) {
      emit(ProductOperationFailure(error: error.toString()));
    }
  }

  void _fetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductsLoading());

      // Fetch products from Firestore
      final productsSnapshot = await firestore.collection('products').get();

      // Map Firestore documents to ProductModel objects
      final List<ProductModel> products = productsSnapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
            id: doc.id,
            name: data['name'],
            measurement: data['measurement'],
            price: data['price'].toDouble(),
            qrCodeData: data['qrCodeData']);
      }).toList();

      // Emit ProductsLoaded state with the fetched products
      emit(ProductsLoaded(products: products));
    } catch (error) {
      emit(ProductOperationFailure(error: error.toString()));
    }
  }

  void _searchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductsLoading());

      final productsSnapshot = await firestore.collection('products').get();

      final List<ProductModel> products = productsSnapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
            id: doc.id,
            name: data['name'],
            measurement: data['measurement'],
            price: data['price'].toDouble(),
            qrCodeData: data['qrCodeData']);
      }).toList();

      // Filter products based on the search query
      final filteredProducts = products
          .where((product) =>
                  product.name.toLowerCase().contains(event.query.toLowerCase())
              // ||
              // product.qrCodeData!.toLowerCase().contains(event.query.toLowerCase()
              //)
              )
          .toList();

      emit(ProductsLoaded(products: filteredProducts));
    } catch (error) {
      emit(ProductOperationFailure(error: error.toString()));
    }
  }
}

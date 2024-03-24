import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/auth_bloc/auth_bloc.dart';

import 'package:sample_flutter_project/application/features/product/models/product_model.dart';
import 'package:sample_flutter_project/application/features/product/product_bloc/product_bloc.dart';
import 'package:sample_flutter_project/application/features/product/widgets/empty_screen.dart';

class ProductListingWrapper extends StatelessWidget {
  const ProductListingWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(firestore: FirebaseFirestore.instance)
        ..add(FetchProducts()), // Dispatch FetchProducts event here
      child:  ProductListingPage(),
    );
  }
}

class ProductListingPage extends StatelessWidget {
   ProductListingPage({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        backgroundColor: const Color(0xff263147),
        actions: [
            IconButton(
             
            onPressed: () {
             BlocProvider.of<ProductBloc>(context).add(FetchProducts());
            },
            icon: const Icon(
              Icons.refresh,
            ),
            ),
          
          IconButton(
           
            onPressed: () {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              authBloc.add(LogoutEvent());
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            List<ProductModel> products = state.products.reversed.toList();
            print(products.length);
            return products.isEmpty
                ? const EmptyScreen(
                    title: 'You didnt add any product yet',
                    subtitle: 'add something here :)',
                    imagePath: 'assets/cart.png',
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            BlocProvider.of<ProductBloc>(context).add(SearchProducts(value));
                          },
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(color: Colors.red),
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            hintText: 'Search by name ',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            prefixIcon: const Icon(Icons.search,color: Colors.white,),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _searchController.clear(); // Clear search query
                                // Reset displayed products to full list
                                products = List.from(products);
                                // Update UI
                                BlocProvider.of<ProductBloc>(context).add(FetchProducts());
                              },
                              icon: const Icon(Icons.clear,color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ListTile(
                              title: Text(
                                "Name:${product.name}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Measurement:${product.measurement}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                    "Price:\$${product.price.toStringAsFixed(2)}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              onTap: () {
                                print(product.qrCodeData);
                                Navigator.pushNamed(
                                  context,
                                  '/productDetails',
                                  arguments: {
                                    'name': product.name,
                                    'qrCodeData': product.qrCodeData,
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
          } else if (state is ProductOperationFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProductScreen');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

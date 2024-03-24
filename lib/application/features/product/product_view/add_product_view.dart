import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_project/application/features/auth/widgets/custom_textform_field.dart';

import 'package:sample_flutter_project/application/features/product/product_bloc/product_bloc.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: BlocProvider(
        create: (context) => ProductBloc(firestore: FirebaseFirestore.instance),
        child: const AddProductForm(),
      ),
    );
  }
}

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _measurementController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextFormField(
              controller: _nameController, hintText: "Product Name"),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            controller: _measurementController,
            hintText: "Measurement",
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            controller: _priceController,
            hintText: "Price",
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              final String name = _nameController.text;
              final String measurement = _measurementController.text;
              final double price =
                  double.tryParse(_priceController.text) ?? 0.0;

              if (name.isNotEmpty && measurement.isNotEmpty && price > 0) {
                // Dispatch AddProduct event
                context.read<ProductBloc>().add(
                      AddProduct(
                          name: name,
                          measurement: measurement,
                          price: price,
                          qrCodeData: name),
                    );

                // Clear text fields after adding product
                _nameController.clear();
                _measurementController.clear();
                _priceController.clear();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added successfully'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields correctly'),
                  ),
                );
              }
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String productName = args['name'] as String;
    //final String qrCodeData = args['qrCodeData'] as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: productName,
              version: QrVersions.auto,
              size: 200.0,
              foregroundColor: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              productName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

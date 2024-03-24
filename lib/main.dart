import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_project/application/features/auth/views/login_view.dart';
import 'package:sample_flutter_project/application/features/auth/views/register_view.dart';
import 'package:sample_flutter_project/application/features/product/product_view/add_product_view.dart';
import 'package:sample_flutter_project/application/features/product/product_view/product_details_screen.dart';

import 'package:sample_flutter_project/application/features/product/product_view/product_list_view.dart';
import 'package:sample_flutter_project/application/features/splash/splash_view.dart';
import 'package:sample_flutter_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
            displayLarge: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            bodySmall: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff263147), foregroundColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xff263147),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => SplashScreen(),
        '/login': (ctx) => const LoginViewWrapper(),
        '/register': (ctx) => const RegisterPageWrapper(),
        '/productDetails': (ctx) => const ProductDetailsScreen(),
        '/productListingPage': (ctx) => const ProductListingWrapper(),
        '/addProductScreen': (ctx) => const AddProductPage(),
      },
    );
  }
}

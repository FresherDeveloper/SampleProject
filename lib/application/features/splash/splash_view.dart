import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/auth_bloc/auth_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/views/login_view.dart';
import 'package:sample_flutter_project/application/features/product/product_bloc/product_bloc.dart';
import 'package:sample_flutter_project/application/features/product/product_view/product_list_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
              ),
              BlocProvider<ProductBloc>(
                create: (BuildContext context) => ProductBloc(
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            ],
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const ProductListingWrapper();
                } else if (state is UnAuthenticated) {
                  return const LoginView();
                } else {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff263147),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/splash.png",
              height: 350,
              width: 350,
            ),
            Text(
              "Shop your best",
              style: Theme.of(context).textTheme.displayLarge,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/auth_bloc/auth_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/widgets/custom_textform_field.dart';

class LoginViewWrapper extends StatelessWidget {
  const LoginViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authblocc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        );
      }

      if (state is Authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/productListingPage', (route) => false);
        });
      }

      return Scaffold(
          body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login with Email",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
                controller: _emailController, hintText: "Enter Email"),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
                obscureText: true,
                controller: _passwordController,
                hintText: "Enter Password"),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                authblocc.add(LoginEvent(
                    password: _passwordController.text.trim(),
                    email: _emailController.text.trim()));
              },
              child: Container(
                height: 52,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange),
                child: Center(
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't you have an account?",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                    // style: TextButton.styleFrom(
                    //   foregroundColor: Colors.blue,
                    //   textStyle: TextStyle(fontSize: 16)
                    // ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Register",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blue),
                    ))
              ],
            )
          ],
        ),
      ));
    });
  }
}


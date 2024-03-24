import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/auth_bloc/auth_bloc.dart';
import 'package:sample_flutter_project/application/features/auth/models/user_model.dart';
import 'package:sample_flutter_project/application/features/auth/widgets/custom_textform_field.dart';

class RegisterPageWrapper extends StatelessWidget {
  const RegisterPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authbloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        });
      }

      return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xff263147),
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: double.infinity,
              width: double.infinity,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register with Email",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            controller: _emailController,
                            hintText: "Enter Email"),
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
                        CustomTextFormField(
                            controller: _nameController,
                            hintText: "Enter Name"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            controller: _phoneController,
                            hintText: "Enter Phone"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            controller: _addressController,
                            hintText: "Enter Address"),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            UserModel user = UserModel(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneController.text,
                                address: _addressController.text);

                            authbloc.add(SignupEvent(user: user));
                          },
                          child: Container(
                            height: 52,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.orange),
                            child: Center(
                              child: Text(
                                "Register",
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
                              "Already have an Account?",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Login",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.blue),
                                ))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )));
    });
  }
}

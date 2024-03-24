import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String imagePath, title, subtitle;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              imagePath,
              width: double.infinity,
              height: size.height * 0.4,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Whoops!',
              style: TextStyle(
                  color: Colors.red, fontSize: 40, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            textWidget(text: title),
            const SizedBox(
              height: 20,
            ),
            textWidget(text: subtitle),
            SizedBox(
              height: size.height * 0.1,
            ),
          ]),
    ));
  }

  Text textWidget({required String text}) => Text(
        text,
        style: TextStyle(color: Colors.cyan, fontSize: 20),
      );
}

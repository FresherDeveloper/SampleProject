# sample_flutter_project

A new Flutter project.

## Getting Started
command to run project
flutter run
Pin setting I could not implement I am giving a sample code what I know to implement
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login with PIN Setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

void _showPinSetupDialog(
    {required BuildContext context, required String message}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String pin = '';
      TextEditingController pinController = TextEditingController();
      return AlertDialog(
        title: Text('Set up PIN'),
        content: TextField(
          controller: pinController,
          decoration: InputDecoration(labelText: 'Enter your PIN'),
          obscureText: true,
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Save PIN logic goes here
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('pin', pin);


              Navigator.of(context).pop();


                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(),
                  ),
                ).then((value) =>
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                    )));




            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  bool _loggedIn = false;
  bool _pinExists = false;
  bool _isClicked = false;
  @override
  void initState() {
    _checkPinExists();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController.dispose();
    _pinController.dispose();

    super.dispose();
  }

  Future<void> _checkPinExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _pinExists = prefs.getString('pin') != null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: !_pinExists||_isClicked ? buildColumn1(context) : buildColumn2(context),
      ),
    );
  }

  Widget buildColumn1(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Simulate login logic
            if (_usernameController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty) {
              // Perform actual authentication here
              // For demonstration purpose, let's consider any non-empty username and password combination as successful login
              setState(() {
                _loggedIn = true;
              });

             !_isClicked? _showPinSetupDialog(
                  context: context, message: "Set pin successfully"):  Navigator.pushReplacement(
               context,
               MaterialPageRoute(
                 builder: (BuildContext context) => HomeScreen(),
               ),
             ).then((value) {
               _passwordController.clear();
               _usernameController.clear();
             });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please enter both username and password.'),
              ));
            }
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  Widget buildColumn2(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _pinController,
          decoration: InputDecoration(labelText: 'Enter Pin'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? savedPin = prefs.getString('pin');
            // Simulate login logic
            if (_pinController.text.isNotEmpty&&savedPin==_pinController.text) {
              // Perform actual authentication here
              // For demonstration purpose, let's consider any non-empty username and password combination as successful login
              setState(() {
                _loggedIn = true;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
              _pinController.clear();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please enter your valid pin'),
              ));
            }
          },
          child: Text('Login'),
        ),
        SizedBox(height: 20),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Forgot Pin?",
                style: TextStyle(
                  color: Colors.black,

                ),
              ),
              WidgetSpan(
                child: SizedBox(
                  width: 5, // Adjust the width as needed
                ),
              ),
              TextSpan(
                text: "Click here",
                style: TextStyle(
                  color: Colors.blue,

                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      _isClicked=true;
                    });
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          ElevatedButton(
            onPressed: () {
              _logout(context);
            },
            child: Text('Logout'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _resetPin(context);
            },
            child: Text('Reset PIN'),
          ),
        ],
      ),
      body: Center(child: Text("Home Screen")),
    );
  }

  void _resetPin(BuildContext context) async {
    // Reset PIN logic goes here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pin');

    _showPinSetupDialog(context: context, message: "Reset successfully");
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    ).then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("LogOut successfully"),
        )));
  }
}


This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

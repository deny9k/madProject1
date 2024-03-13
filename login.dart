import 'package:flutter/material.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 14),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 14),
              TextButton(
                onPressed: _goToSignUp,
                child: Text('New user? Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final users = await _dbHelper.getUsersByEmail(email);
    for (var user in users) {
      if (user[ExpenseDatabase.username] == email &&
          user[ExpenseDatabase.password] == password) {
        // Successfully logged in.
        // Navigate to the home page or display a success message.
        var theUserId = user[ExpenseDatabase.userId];
        ExpenseDatabase.loggedInUserIdValue = theUserId;
        print('Successfully logged in.');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ExpenseTrackerApp()),
        );
        return;
      }
    }

  void _invalidLoginMsg() {
    final snackBar = SnackBar(
      content: Text('Incorrect username or password'),
      duration: Duration(seconds: 3), // Set the duration as per your need
    );
    _scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }

  void _goToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}

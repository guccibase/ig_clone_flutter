import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/login_screen.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';

class signupScreen extends StatefulWidget {
  static final String id = 'signupScreen';

  @override
  _signupScreenState createState() => _signupScreenState();
}

class _signupScreenState extends State<signupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _phoneNumber, _userName;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      AuthService.signUpUser(context, _userName, _email, _password);

      print(_email);
      print(_password);
      print(_phoneNumber);
      print(_userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Instagram',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 50,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone number'),
                        onSaved: (input) => _phoneNumber = input,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 30.0),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 30.0),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (input) => input.trim().isEmpty
                            ? 'Username must not be Empty'
                            : null,
                        onSaved: (input) => _userName = input,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 30.0),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) => input.length < 8
                            ? 'Must be at least 8 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 250,
                        child: FlatButton(
                          onPressed: () {
                            _submit();
                          },
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, loginScreen.id);
                          },
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Back to log in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

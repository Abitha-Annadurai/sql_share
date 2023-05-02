import 'package:flutter/material.dart';
import 'package:gomsql/profile_page.dart';
import 'package:gomsql/register_screen.dart';
import 'package:gomsql/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailtext = TextEditingController();
  final _passtext = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  String _error = "";
  String _email = "";
  String _password = "";

  @override
  void dispose() {
    _emailtext.dispose();
    _passtext.dispose();
    super.dispose();
  }

//Get All Users
  List<dynamic> _users = [];

  void _allUsers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _users = data;
      print(_users);
    });
  }

  @override
  void initState() {
    _allUsers();
    super.initState();
  }

  //Check Login Credentials
  Future _checkUser(String mailid, String password) async {
    final existingUser = _users.firstWhereOrNull((element) =>
    element['mailid'] == mailid && element['password'] == password);
    print(existingUser);
    if (existingUser == null) {
      setState(() {
        _error = "Invalid UserId / password";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid Mailid / Password!'),
      ));
    }
    print(existingUser);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true);
    prefs.setString("name", existingUser['name']);
    prefs.setInt("id", existingUser['id']);
    prefs.setString("mobileno", existingUser['mobileno']);
    prefs.setString("mailid", existingUser['mailid']);
    prefs.setString("password", existingUser['password']);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
    ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    children: [
                      SizedBox(width: 20.0,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailtext,
                          decoration: const InputDecoration(
                            labelText: "Enter Email Id",),
                          validator: (text) {
                            if (text == null || text == "") {
                              return "Please Enter Email Id";
                            }
                            if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(text)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                            },
                          onFieldSubmitted: (text) => setState(() {
                            _email = text;
                            FocusScope.of(context).requestFocus(focusNode2);
                          }),
                        ),
                      ),
                    ]),
                Row(
                  children: [
                    const SizedBox(width: 20.0,),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        focusNode: focusNode2,
                        controller: _passtext,
                        obscureText: true,
                        maxLength: 8,
                        decoration: const InputDecoration(
                          labelText: "Enter Password"),
                        validator: (text) {
                          if (text == null || text == "") {
                            return "Please Enter Password";
                          } else if (text.length < 8) {
                            return "Password too Short";
                          }
                          return null;
                          },
                        onChanged: (text) => setState(
                              () => _password = text,
                        )),),
                  ],
                ),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          FocusScope.of(context).unfocus();
                          await _checkUser(_emailtext.text, _passtext.text);
                        }
                        },
                      child: const Text("Sign In"),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                        },
                      child: const Text("Register", style: TextStyle(color: Colors.white),),
                    ),],),],),),
        ),
      ),
    );
  }
}

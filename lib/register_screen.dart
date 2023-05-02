import 'package:flutter/material.dart';
import 'package:gomsql/sql_helper.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  //bool _validate = false;
  final _nametext = TextEditingController();
  final _mobiletext = TextEditingController();
  final _emailtext = TextEditingController();
  final _passtext = TextEditingController();
  final _cpasstext = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  String _name = "";
  String _mobile = "";
  String _email = "";
  String _password = "";
  String _cpassword = "";

  // Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _nametext.text, _mobiletext.text, _emailtext.text, _passtext.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully Added'),
    ));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          title: Text('Registraton'),
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
    const SizedBox(
    width: 20.0,
    ),

    SizedBox(
    width: 300,
    child: TextFormField(
    focusNode: focusNode1,
    keyboardType: TextInputType.name,
    controller: _nametext,
    decoration: const InputDecoration(
    labelText: "Enter User Name",),
    validator: (text) {
    if (text == null || text == "") {
    return "Please Enter User Name";
    }

    return null;
    },
    onFieldSubmitted: (text) => setState(() {
    _name = text;
    FocusScope.of(context).requestFocus(focusNode2);
      //_validate = true;
    }),
    ),
    ),
      ],
    ),
    Row(
    children: [
    const SizedBox(
    width: 20.0,
    ),

    SizedBox(
    width: 300,
    child: TextFormField(
    focusNode: focusNode2,
    keyboardType: TextInputType.number,
    controller: _mobiletext,
    maxLength: 10,
    decoration: const InputDecoration(
    labelText: "Enter Mobile Number",
    ),
    validator: (text) {
    if (text == null || text == "") {
    return "Please Enter Mobile Number";
    } else if (!RegExp(
    r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(text)) {
    return "Please Enter a Valid Phone Number";
    }

    return null;
    },
    onFieldSubmitted: (text) => setState(() {
    _mobile = text;
    FocusScope.of(context).requestFocus(focusNode3);
    //_validate = true;
    }),
    ),
    ),
    ],
    ),
    Row(
    children: [
    const SizedBox(
    width: 20.0,
    ),
    SizedBox(
    width: 300,
    child: TextFormField(
    focusNode: focusNode3,
    keyboardType: TextInputType.emailAddress,
    controller: _emailtext,
    decoration: const InputDecoration(
    labelText: "Enter Email Id",
    ),
    validator: (text) {
    if (text == null || text == "") {
    return "Please Enter Email Id";
    }
    if (!RegExp(
    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(text)) {
    return 'Please enter a valid email';
    }

    return null;
    },
    onFieldSubmitted: (text) => setState(() {
    _email = text;
    FocusScope.of(context).requestFocus(focusNode4);
    //_validate = true;
    }),
    ),
    ),
    ],
    ),
    Row(
    children: [
    const SizedBox(
    width: 20.0,
    ),
    SizedBox(
    width: 300,
    child: TextFormField(
    focusNode: focusNode4,
    controller: _passtext,
    obscureText: true,
    maxLength: 8,
    decoration: const InputDecoration(
    labelText: "Enter Password",
    ),
    validator: (text) {
    if (text == null || text == "") {
    return "Please Enter Password";
    } else if (text.length < 8) {
    return "Password too Short";
    }

    return null;
    },
    onFieldSubmitted: (text) => setState(() {
    _password = text;
    FocusScope.of(context).requestFocus(focusNode5);
    //_validate = true;
    }),
    ),
    ),
    ],
    ),
    Row(
    children: [
    const SizedBox(
    width: 20.0,
    ),
    SizedBox(
    width: 300,
    child: TextFormField(
    focusNode: focusNode5,
    controller: _cpasstext,
    obscureText: true,
    maxLength: 8,
    decoration: const InputDecoration(
    labelText: "Enter Confirm Password",
    ),
    validator: (text) {
    if (text == null || text == "") {
    return "Please Enter Confirm Password";
    } else if (text.length < 8) {
    return "Password too Short";
    } else if (text != _passtext.text) {
    return "Password & Confirm Password doesnot match";
    }

    return null;
    },
    onChanged: (text) => setState(
    () => _cpassword = text,
    ),
    ),
    ),
    ],
    ),
    const SizedBox(
    height: 20.0,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    ElevatedButton(
    onPressed: () async {
      final isValid = _formKey.currentState!.validate();

      if (isValid) {
        await _addItem();
        FocusScope.of(context).unfocus();
      }
    },
      child: const Text(
        "Save",
        style: TextStyle(color: Colors.white),
      ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}

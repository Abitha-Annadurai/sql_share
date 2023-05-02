import 'package:flutter/material.dart';
import 'package:gomsql/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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

  String userName = "";
  String userMobileNo = "";
  String userMailid = "";
  String userPassword = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    getSharePrefData();
  }

  void getSharePrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userName = pref.getString("name").toString();
      userMailid = pref.getString("mailid").toString();
      userMobileNo = pref.getString("mobileno").toString();
      userPassword = pref.getString("password").toString();
      userId = pref.getInt("id").toString();

      _nametext.text = userName;
      _mobiletext.text = userMobileNo;
      _emailtext.text = userMailid;
      _passtext.text = userPassword;
      _cpasstext.text = userPassword;
    });
  }

  //Logout Function
  void logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("login");
    pref.remove("name");
    pref.remove("mailid");
    pref.remove("password");
    pref.remove("id");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully Account deleted!'),
    ));
    logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Row(
          children: [
            TextButton(onPressed: (){
              _deleteItem(int.parse(userId));
            },
                child: Text('Delete')),
            TextButton(onPressed: (){
              logOut();
            },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
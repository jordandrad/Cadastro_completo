import 'package:flutter/material.dart';
import 'package:personal_finance_app/login.dart';
import 'package:personal_finance_app/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  TextEditingController controllerNewUsername = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerNewEmail = TextEditingController();
  bool hidePassword = true;
  String buttonPassword = "Show Password";
  String feedback = "";

  void createAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("hasAccount")!) {
      setState(() {
        feedback =
            "It looks like you already have an account here, try to delete and create a new account!";
      });
    } else {
      prefs.setString("Username", controllerNewUsername.text.toString());
      prefs.setString("Password", controllerNewPassword.text.toString());
      prefs.setString("Email", controllerNewEmail.text.toString());
      controllerNewUsername.clear();
      controllerNewPassword.clear();
      controllerNewEmail.clear();
      prefs.setBool("hasAccount", true);
      Navigator.pop(context);
    }
    prefs.setBool("hasAccount", true);
    print(prefs.getBool("hasAccount").toString());
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("hasAccount");
    prefs.getString("Username");
    prefs.getString("Password");
    prefs.getString("Email");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Sign-up"),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: Text(
                    "We'll need some info about you",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: controllerNewUsername,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        label: Text("Type your new username here")),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: controllerNewPassword,
                    keyboardType: TextInputType.name,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      label: Text("Type your new password here"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: controllerNewEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(label: Text("Type your email here")),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(feedback),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (controllerNewEmail.text.toString().isNotEmpty &&
                              controllerNewPassword.text
                                  .toString()
                                  .isNotEmpty &&
                              controllerNewEmail.text.toString().isNotEmpty) {
                            createAccount();

                            setState(() {
                              feedback = "";
                            });
                          }
                         

                          if (controllerNewEmail.text.toString().isEmpty ||
                              controllerNewPassword.text.toString().isEmpty ||
                              controllerNewEmail.text.toString().isEmpty) {
                            setState(() {
                              feedback = "Please fill all of the text fields";
                            });
                          }
                        },
                        child: Text("Create account"))),
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                          if (hidePassword) {
                            setState(() {
                              buttonPassword = "Show password";
                            });
                          } else {
                            setState(() {
                              buttonPassword = "Hide password";
                            });
                          }
                        },
                        child: Text(buttonPassword))),
              ],
            ),
          ),
        ));
  }
}

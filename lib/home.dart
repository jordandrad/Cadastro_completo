import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  String username = "";
  String password = "";
  String email = "";
  String feedback = "";
  TextEditingController controllerNewUsername = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerNewEmail = TextEditingController();
  bool hidePassword = true;

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("Username")!;
      password = prefs.getString("Password")!;
      email = prefs.getString("Email")!;
    });
  }

  void deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("Username");
    prefs.remove("Password");
    prefs.remove("Email");
    prefs.setBool("hasAccount", false);
    print(prefs);
    print(prefs.getBool("hasAccount"));
  }

  void updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("Username", controllerNewUsername.text.toString());
    prefs.setString("Password", controllerNewPassword.text.toString());
    prefs.setString("Email", controllerNewEmail.text.toString());
    controllerNewUsername.clear();
    controllerNewPassword.clear();
    controllerNewEmail.clear();
    prefs.setBool("hasAccount", true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Personal Finance App"),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 30),
                  child: Text("Hello $username! This is your current data.",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text("Current username"),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  child: Container(
                      height: 30,
                      width: 300,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Center(
                        child: Text(
                          username,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Text("Current password"),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  child: Container(
                      height: 30,
                      width: 300,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Center(
                        child: Text(
                          password,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Text("Current email"),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 70, left: 20, right: 20),
                  child: Container(
                      height: 30,
                      width: 300,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Center(
                        child: Text(
                          email,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "Are you sure? This action can't be undone."),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        deleteAccount();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No")),
                                ],
                              ),
                            );
                          });
                    },
                    child: Text("Delete account")),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text("Edit your info"),
                                  content: Container(
                                    height: 300,
                                    width: 600,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: TextField(
                                              controller: controllerNewUsername,
                                              keyboardType: TextInputType.name,
                                              decoration: InputDecoration(
                                                  label: Text(
                                                      "Type your new username here")),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: TextField(
                                              controller: controllerNewPassword,
                                              keyboardType: TextInputType.name,
                                              obscureText: hidePassword,
                                              decoration: InputDecoration(
                                                label: Text(
                                                    "Type your new password here"),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 15),
                                            child: TextField(
                                              controller: controllerNewEmail,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  label: Text(
                                                      "Type your new email here")),
                                            ),
                                          ),
                                          Text(
                                            feedback,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 50,
                                            ),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (controllerNewEmail.text
                                                          .toString()
                                                          .isNotEmpty &&
                                                      controllerNewPassword.text
                                                          .toString()
                                                          .isNotEmpty &&
                                                      controllerNewEmail.text
                                                          .toString()
                                                          .isNotEmpty) {
                                                    updateUser();
                                                    setState(() {
                                                      feedback = "";
                                                    });
                                                  } else {
                                                    setState(() {
                                                      feedback =
                                                          "Please fill all of the text fields";
                                                    });
                                                  }
                                                },
                                                child: Text("Edit")),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            });
                      },
                      child: Text("Edit info")),
                )
              ],
            ),
          ),
        ));
  }
}

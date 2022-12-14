import 'package:flutter/material.dart';
import 'package:personal_finance_app/home.dart';
import 'package:personal_finance_app/main.dart';
import 'package:personal_finance_app/signup.dart';
import 'package:personal_finance_app/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool("hasAccount");
    prefs.getString("Username");
    prefs.getString("Password");
    prefs.getString("Email");
    if (prefs.getBool("hasAccount") == true) {
      setState(() {
        mainText = "Hi ${prefs.getString("Username")}, welcome back!";
      });
    } else {
      setState(() {
        mainText = "Welcome to your app!";
      });
    }
  }

  void verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_controllerUserName.text.toString() == prefs.getString("username") &&
        _controllerPassword.text.toString() == prefs.getString("password")) {
      setState(() {
        statusText = "You have successfully logged in!" +
            _controllerUserName.text.toString() +
            _controllerPassword.text.toString();
        colorStatusText = Colors.green;
      });
      navigateToHome();
    } else {
      setState(() {
        statusText = "Try again!" +
            _controllerUserName.text.toString() +
            _controllerPassword.text.toString();
        colorStatusText = Colors.red;
      });
    }
  }

  check() async {
    suo();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("hasAccount") == true &&
        _controllerUserName.text.toString() == prefs.getString("Username") &&
        _controllerPassword.text.toString() == prefs.getString("Password")) {
      navigateToHome();
    } else if (prefs.getBool("hasAccount") == false) {
      setState(() {
        statusText =
            "It looks like you don't have an account here yet, try creating a new account, its free!";
      });
    } else {
      setState(() {
        statusText = statusText = "Incorrect username or password";
      });
    }
  }

  suo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("Username"));
    print(prefs.getString("Password"));
    print(prefs.getBool("hasAccount"));
    if (prefs.getBool("hasAccount") == true) {
      setState(() {
        mainText = "Hi ${prefs.getString("Username")}, welcome back!";
      });
    } else {
      setState(() {
        mainText = "Welcome to your app!";
      });
    }
  }

  void navigateToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void checkEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_controllerCheckEmail.text.toString() == prefs.getString("Email") &&
        prefs.getBool("hasAccount") == true) {
      setState(() {
        indexRecover = 1;
        checkedPassword = prefs.getString("Password")!;
      });
    } else {
      setState(() {
        feedbackRecover = "Try again";
      });
    }
  }

  Future<Map<String, dynamic>>? userInfo;
  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerCheckEmail = TextEditingController();
  String mainText = "Hi, welcome to your app!";
  var colorStatusText = Colors.black;
  String statusText = "";
  int indexRecover = 0;
  String checkedPassword = "";
  String feedbackRecover = "First, enter your email below";
  Widget passwordScreen() => Container(
      height: 120,
      width: 120,
      child: Column(
        children: [
          Text("This is your current password"),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Container(
                height: 30,
                width: 300,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Text(
                    checkedPassword,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  indexRecover = 0;
                });
              },
              child: Text("Back"))
        ],
      ));
  Widget recoverScreen() => Container(
        height: 200,
        width: 120,
        child: Column(
          children: [
            Text(feedbackRecover),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _controllerCheckEmail,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    InputDecoration(label: Text("Type your email here")),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 110, top: 20),
              child:
                  ElevatedButton(onPressed: checkEmail, child: Text("Recover")),
            )
          ],
        ),
      );

  Widget build(BuildContext context) {
    List<Widget> recover = [recoverScreen(), passwordScreen()];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Sign-up and Login"),
        ),
      ),
      body: FutureBuilder(
        future: userInfo,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text("Error: " + snapshot.error.toString());
              } else {
                return Center(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mainText,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: colorStatusText),
                                ),
                              ),
                              TextField(
                                controller: _controllerUserName,
                                keyboardType: TextInputType.name,
                                decoration:
                                    InputDecoration(label: Text("Username")),
                              ),
                              TextField(
                                controller: _controllerPassword,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration:
                                    InputDecoration(label: Text("Password")),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signup()));
                                    print("New account tapped");
                                  },
                                  child: Text(
                                    "New here? Sign-up now!",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 10),
                                child: ElevatedButton(
                                    onPressed: check, child: Text("Enter")),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Recover password"),
                                              content: recover[indexRecover],
                                            );
                                          });
                                    },
                                    child: Text("Recover password")),
                              )
                            ])));
              }
          }
        },
      ),
    );
  }
}

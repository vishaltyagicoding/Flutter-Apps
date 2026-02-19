import 'package:bmi_app/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'textFeild_.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  static const String keyName = "userName";
  static const String PASSWORD = "password";
  var userName = TextEditingController();
  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: Colors.green.shade200,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  radius: 30,
                ),
              ),
              TextFeilds().makeTextField(
                text: "Enter UserName",
                control: userName,
                icon: Icon(Icons.supervised_user_circle),
                textInnputType: TextInputType.text,
              ),
              TextFeilds().makeTextField(
                text: "Enter Password",
                control: password,
                icon: Icon(Icons.password),
                textInnputType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () async {
                  var username = userName.text.toString();
                  var passwor = password.text.toString();

                  var pref = await SharedPreferences.getInstance();
                  pref.setString(keyName, username);
                  pref.setString(PASSWORD, passwor);
                  pref.setBool("isLogin", true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FirstPage()),
                  );
                },
                child: Text("Saved"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

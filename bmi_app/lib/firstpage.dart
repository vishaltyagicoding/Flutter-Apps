import 'package:bmi_app/login_page.dart';
import 'package:bmi_app/textFeild_.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextFeilds field = TextFeilds();

  var feet = TextEditingController();
  var inch = TextEditingController();
  var weight = TextEditingController();
  var result = "";
  var bgColor = [Color(0xffffecd2), Color(0xfffcb69f)];
  String condition = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("BMI CALCULATOR")),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // ONLY THIS LINE IS ADDED
          ElevatedButton(
            child: Text("LogOut"),

            onPressed: () {
              logOut();
              // Add your logout logic here
              print("Logout button pressed");
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent.shade100,
      body: SingleChildScrollView(
        // Add this wrapper
        child: Container(
          width: double.infinity,
          // Remove height: double.infinity or change to minHeight
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: bgColor,
              begin: FractionalOffset(1.0, 0.0),
              end: FractionalOffset(0.0, 1.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome to BMI Calculator",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: field.makeTextField(
                  text: "Enter Your Height(in feet)",
                  control: feet,
                  icon: Icon(Icons.height),
                  textInnputType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: field.makeTextField(
                  text: "Enter Your Height(in inch)",
                  control: inch,
                  icon: Icon(Icons.line_weight),
                  textInnputType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: field.makeTextField(
                  text: "Enter Your Weight",
                  control: weight,
                  icon: Icon(Icons.line_weight),
                  textInnputType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    var w = weight.text.toString();
                    var n = inch.text.toString();
                    var f = feet.text.toString();
                    if (w != "" && f != "" && n != "") {
                      int f = int.parse(feet.text.toString());
                      int n = int.parse(inch.text.toString());
                      double w = double.parse(weight.text.toString());
                      double meters = (f * 0.3048) + (n * 0.0254);

                      var bmi = (w / (meters * meters));

                      if (bmi < 18) {
                        bgColor = [Color(0xfffa709a), Color(0xfffee140)];
                        condition = "Under Weight";
                      } else if (bmi < 25) {
                        bgColor = [Color(0xffd4fc79), Color(0xff96e6a1)];
                        condition = "Normal";
                      } else {
                        bgColor = [Color(0xff30cfd0), Color(0xff330867)];
                        condition = "Over Weight";
                      }
                      result =
                          " Your BMI is ${bmi.toStringAsFixed(2)} you are $condition";
                    } else {
                      result = "please fill all requrement blanks!";
                      bgColor = [Color(0xffffecd2), Color(0xfffcb69f)];
                    }
                    setState(() {});
                  },
                  child: Text("Calculate"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Result = $result",
                  style: TextStyle(
                    color: Colors.brown.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }

  void logOut() async {
    var logout = await SharedPreferences.getInstance();
    logout.setBool("isLogin", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rider_app/brand_colors.dart';
import 'package:rider_app/screens/login_page.dart';
import 'package:rider_app/screens/mainpage.dart';
import 'package:rider_app/widgets/progress_dialog.dart';
import 'package:rider_app/widgets/taxi_button.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  var fullNamecontroller = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    // Show progress dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: "Registering you in",
            ));
    final User user = (await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((ex) {
      // check error and display
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;

    Navigator.pop(context);

    if (user != null) {
      print("User registered");
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child("users/${user.uid}");
      // Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullNamecontroller.text,
        'phoneNumber': phoneController.text,
        'email': emailController.text,
      };

      newUserRef.set(userMap);

      // Take the user to mainPage after registering
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 70),
                Image(
                  image: AssetImage('images/logo.png'),
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Create a Rider Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Brand-Bold',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Full name",
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        controller: fullNamecontroller,
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone number",
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        controller: phoneController,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        controller: emailController,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        controller: passwordController,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                        color: BrandColors.colorGreen,
                        title: "Register",
                        onPressed: () async {
                          // Check network availability
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connectivity');
                          }

                          // field validation checks
                          if (fullNamecontroller.text.length < 3) {
                            showSnackBar("Please provide a valid full name");
                            return;
                          }
                          if (phoneController.text.length < 9) {
                            showSnackBar("Please provide a valid phone number");
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                "Please provide a valid email address");
                            return;
                          }
                          if (passwordController.text.length < 8) {
                            showSnackBar(
                                "Password must be atleast 8 characters long");
                            return;
                          }

                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (route) => false);
                  },
                  child: Text("Already have a Rider account? Login instead"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

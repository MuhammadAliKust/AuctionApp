import 'dart:ui';

import 'package:auctionapp/Screens/DashBoard.dart';
import 'package:auctionapp/Screens/ForgotPassword.dart';
import 'package:auctionapp/Screens/Signup.dart';
import 'package:auctionapp/Widgets/dialog.dart';
import 'package:auctionapp/application/errorStrings.dart';
import 'package:auctionapp/application/loginBusinessLogic.dart';
import 'package:auctionapp/configs/enums.dart';
import 'package:auctionapp/infrastructure/services/authServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _pwdcontroller = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
  }

  LoginBusinessLogic data = LoginBusinessLogic();

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthServices>(context);
    return Scaffold(
      body: LoadingOverlay(
        isLoading: auth.status == Status.Authenticating,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "Using your emial or username and password",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "YOUR EMAIL/USERNAME",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 340,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Email is Required';
                                }

                                if (!RegExp(
                                        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email Address';
                                }

                                return null;
                              },
                              controller: _emailcontroller,
                              decoration: InputDecoration(
                                  hintText: "Enter Your Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "YOUR PASSWORD",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 340,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "* Password is  Required";
                                } else if (value.length < 6) {
                                  return "Password should be atleast 6 characters";
                                } else if (value.length > 15) {
                                  return "Password should not be greater than 15 characters";
                                } else
                                  return null;
                              },
                              obscureText: true,
                              controller: _pwdcontroller,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.remove_red_eye),
                                  hintText: "Enter Your Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Text(
                          "Forgot Password",
                          style: GoogleFonts.poppins(
                            decoration: TextDecoration.underline,
                            textStyle: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        loginUser(
                            context: context,
                            data: data,
                            email: _emailcontroller.text,
                            auth: auth,
                            password: _pwdcontroller.text);
                      },
                      child: Container(
                        height: 75,
                        width: 350,
                        child: Card(
                          color: Color(0xff209CEE),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(33)),
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an account?",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        "  Signup",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ),
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

  loginUser(
      {@required BuildContext context,
      @required LoginBusinessLogic data,
      @required String email,
      @required AuthServices auth,
      @required String password}) {
    data
        .teacherLoginUserLogic(
      context,
      email: email,
      password: password,
    )
        .then((val) async {
      if (auth.status == Status.Authenticated) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()));
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}

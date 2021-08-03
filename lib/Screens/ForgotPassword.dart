import 'package:auctionapp/Screens/bothApps.dart';
import 'package:auctionapp/Widgets/dialog.dart';
import 'package:auctionapp/Widgets/navigation_dialog.dart';
import 'package:auctionapp/application/errorStrings.dart';
import 'package:auctionapp/configs/enums.dart';
import 'package:auctionapp/infrastructure/services/authServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _forgotpwdcontroller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  ProgressDialog pr;
  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Forgot Your",
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
                      "Password ?",
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
                      "Give Your email adress you used during registration",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "YOUR EMAIL",
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
                      controller: _forgotpwdcontroller,
                      decoration: InputDecoration(
                          hintText: "Enter Your Email",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  await pr.show();
                  _forgotPassword(context);
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
                        "Send Email",
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
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _forgotPassword(BuildContext context) {
    AuthServices _services = Provider.of<AuthServices>(context, listen: false);
    _services
        .forgotPassword(context, email: _forgotpwdcontroller.text)
        .then((val) async {
      await pr.hide();
      if (_services.status == Status.Authenticated) {
        showNavigationDialog(context,
            message:
                "An email with password reset link has been sent to your email inbox",
            buttonText: "Okay", navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BothApps()));
        }, secondButtonText: "", showSecondButton: false);
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}

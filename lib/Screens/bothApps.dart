import 'package:auctionapp/Screens/Login.dart';
import 'package:auctionapp/Screens/adminLogin.dart';
import 'package:flutter/material.dart';

class BothApps extends StatelessWidget {
  const BothApps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Role"),
      ),
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            child: Text("Login As User"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }),
        RaisedButton(
            child: Text("Login As Admin"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()));
            }),
      ],
    );
  }
}

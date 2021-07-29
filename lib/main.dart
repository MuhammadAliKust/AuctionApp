import 'package:auctionapp/Screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/app_state.dart';
import 'application/errorStrings.dart';
import 'application/signUpBusinissLogic.dart';
import 'infrastructure/services/authServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignUpBusinessLogic()),
      ChangeNotifierProvider(create: (_) => AppState()),
      ChangeNotifierProvider(create: (_) => ErrorString()),
      ChangeNotifierProvider(
        create: (_) => AuthServices.instance(),
      ),
      StreamProvider(
        create: (context) => context.read<AuthServices>().authState,
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

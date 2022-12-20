// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_unnecessary_containers, file_names, use_key_in_widget_constructors, unused_local_variable, unused_import

import 'package:eventos/google_sign_in.dart';
import 'package:eventos/loginpage.dart';
import 'package:eventos/profilepage.dart';
import 'package:eventos/userHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './EventBox.dart';
//import 'eventpage.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  //static var routeName;

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return VerifyEmail();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Something went  wrong'),
          );
        } else {
          return LoginPage();
        }
      },
    ));
  }
}

class VerifyEmail extends StatelessWidget {
  ///const VerifyEmail({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    String? userEmail = user.email;
    if (userEmail?.substring(userEmail.length - 7) != "tce.edu") {
      provider.logout();
    } else {
      return UserHomePage();
    }
    return Center(
      child: CircularProgressIndicator()
      //Text('Verifying...'),
    );
  }
}

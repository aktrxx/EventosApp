// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

//import 'package:eventos/AdminHomePage.dart';
//import 'package:eventos/AdminMain.dart';
//import 'package:eventos/HomePage.dart';
import 'package:eventos/google_sign_in.dart';
//import 'package:eventos/tempAdminLogin.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}
class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 47, 104, 236),
                Color.fromARGB(255, 255, 255, 254),
              ],
            )
          ),
        child: Padding(
          //appBar: AppBar(),
          padding: EdgeInsets.all(50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/LOGO.png'),
                //TextField(),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        minimumSize: Size(double.infinity, 50)),
                    icon: FaIcon(FontAwesomeIcons.google),
                    onPressed: () {
                      final provider =
                          Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.googleLogin();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // );
                    },
                    label: Text('Sign in with Google')),
                //TextField(),
                SizedBox(
                  height: 20,
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //         primary: Colors.white,
                //         onPrimary: Colors.black,
                //         minimumSize: Size(double.infinity, 50)),
                //     onPressed: () {
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(builder: (context) => TempLoginWidget()),
                //       );
                //     },
                //     child: Text('Admin Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
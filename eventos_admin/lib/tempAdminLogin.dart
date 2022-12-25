// ignore_for_file: prefer_const_constructors

import 'package:eventos/AdminHomePage.dart';
import 'package:flutter/material.dart';

class TempLoginWidget extends StatefulWidget {
  const TempLoginWidget({super.key});

  @override
  _TempLoginWidgetState createState() => _TempLoginWidgetState();
}

class _TempLoginWidgetState extends State<TempLoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  // void dispose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        /*return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 224, 155, 251),
            title: Text("Eventos"),
            leading: Text("SignIn"))*/

        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Enter Email'),
            ),
            SizedBox(height: 4),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Enter Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(Icons.lock_open, size: 32),
              label: Text(
                'Sign In ',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                if (passwordController.text.toString() == 'admin' &&
                    emailController.text.toString() == 'admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(0)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'CSI') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(1)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'IE') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(2)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'GLUGOT') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(3)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'IT') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(4)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'MECH') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(5)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'SPORTS') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(6)),
                  );
                } else if (passwordController.text.toString() == '12345678' &&
                    emailController.text.toString() == 'COLLEGE') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHome(7)),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            SizedBox(height: 20),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size.fromHeight(50),
            //   ),
            //   icon: Icon(Icons.admin_panel_settings, size: 32),
            //   label: Text(
            //     'Sign in as Admin',
            //     style: TextStyle(fontSize: 24),
            //   ),
            //   onPressed:(() => Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => AdminHome(
            //             //storage: Storage(),
            //           )),
            // )),
            // ),
          ],
        ),
      );
}

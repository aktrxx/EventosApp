// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, empty_constructor_bodies, prefer_const_constructors_in_immutables, unused_import

import 'package:eventos/google_sign_in.dart';
//import 'package:eventos/testscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loginpage.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  //const ProfilePage({Key? key}) : super(key: key);
  //final user = FirebaseAuth.instance.currentUser!;
  //late int access;

  ProfilePage();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    //if (access == 0 || access == 1) {
      if (true){}
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 255, 128, 24),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Profile page')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            Text('User Name : ${user.displayName!}'),
            Text('Email : ${user.email!}'),
            TextButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
            //       Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => LoginPage()),
            // );

                  //Navigator.pop(context);
                  
                },
                child: Text('Logout'))
          ],
        ))
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Text('Signed In as', style: TextStyle(fontSize: 16)),
        //     SizedBox(height: 8),
        //     Text(user.email!, style: TextStyle(fontSize: 20)),
        //     SizedBox(height: 40),
        //     ElevatedButton.icon(

        //       style: ElevatedButton.styleFrom(
        //       primary: Color.fromARGB(255, 255, 128, 24),
        //         minimumSize: Size.fromHeight(50),
        //       ),
        //       icon: Icon(Icons.arrow_back, size: 32),
        //       label: Text(
        //         'Sign Out',
        //         style: TextStyle(fontSize: 24),
        //       ),
        //       onPressed: () => FirebaseAuth.instance.signOut(),
        //     ),
        //   ],
        // )
        );
    //   }
    //   if (access == 1) {
    //     return Scaffold(
    //       body: Center(
    //         child: Text('Admin\'s profile'),
    //       ),
    //     );
    //   } else {
    //     return Scaffold(body: Center(
    //       child: Text('hi'),
    //     ));
    // }
    //);
  }
}

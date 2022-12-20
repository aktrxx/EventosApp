// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

//import 'dart:ui';

import 'package:eventos/eventadd.dart';
//import 'package:eventos/loginpage.dart';
//import 'package:eventos/tempAdminLogin.dart';
//import 'package:eventos/testscreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
//import './size_config.dart';
import 'EventBox.dart';

class AdminHome extends StatelessWidget {
  //const AdminHome({Key? key}) : super(key: key);
  int eventof;

  // ignore: prefer_const_constructors_in_immutables
  AdminHome(this.eventof);
  static String routeName = '/admin_page';

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: AddEvent());
    return AddEvent(eventof);
  }
}

class AddEvent extends StatelessWidget {
  int eventof;
  late String eventOrg;
  AddEvent(this.eventof);
  //const AddEvent({Key? key}) : super(key: key);

  //nobob */
  /*/////////////
 km
 lmll
 knk
 
 kknknknknknkn */
  // final String eventTitle = 'FS\'tival - 22';
  // final String eventTitle1 = 'Smart Hackathon';
  // final String eventTitle2 = 'Blind Coding';
  // final String eventTitle3 = 'Dumb c';
  // final String eventTitle4 = 'Coding contest';
  // final String eventTitle5 = 'TPL';
  // final String eventTitle6 = 'Webinar';

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Events');

  @override
  Widget build(BuildContext context) {
    if (eventof == 1) {
      eventOrg = 'CSI Asssociation';
    } else if (eventof == 2) {
      eventOrg = 'IE Association';
    } else if (eventof == 3) {
      eventOrg = 'GLUGOT TCE';
    } else if (eventof == 4) {
      eventOrg = 'IT';
    } else if (eventof == 5) {
      eventOrg = 'MECH';
    } else if (eventof == 6) {
      eventOrg = 'SPORTS';
    } else if (eventof == 7) {
      eventOrg = 'COLLEGE';
    }
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 169, 5, 51) ,
        backgroundColor: Color.fromARGB(255, 169, 5, 51),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Eventos Admin",
          style: TextStyle(fontSize: 22),
        ),
        leading: GestureDetector(
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Logout?'),
              content: Column(
                children: [Text('Logout as Admin')],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //Navigator.popUntil(ContextAction());
                    // Navigator.popUntil(context,
                    //     ModalRoute.withName(Navigator.defaultRouteName));
                    Navigator.popUntil(context, (route) => route.isFirst);
                    //         Navigator.push(
                    // context,
                    // MaterialPageRoute(
                    //     builder: (context) => TempLoginWidget()
                    // ));
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Icon(
            Icons.account_circle_rounded,
            color: Colors.black,
            size: 36, // add custom icons also
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
            query: ref,
            defaultChild: Center(child: Text('Loading...')),
            itemBuilder: (context, snapshot, animation, index) {
              return EventBox(
                  // eventof: adminof,
                  eventOrgV: eventOrg,
                  eventOrg: snapshot.child('eventOrg').value.toString(),
                  //eventOrg: snapshot.ref,
                  titleText: snapshot.child('Title').value.toString(),
                  descrText: snapshot.child('Description').value.toString(),
                  dateTime:
                      '${snapshot.child('Date').value.toString()} \n ${snapshot.child('Time').value.toString()}',
                  imageLink: snapshot.child('Poster').value.toString(),
                  refe: snapshot.child('refe').value.toString(),
                  pageFrom: 1);
            },
          ))
        ],
      ),
      backgroundColor: Color.fromARGB(255, 220, 133, 194),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 169, 5, 51),
        onPressed: (() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventAddPage(eventOrg
                      //  storage: Storage(),
                      )),
            )),
        label: Text('Add an Event'),
        icon: Icon(Icons.add),
      ),
    );
  }
}


// //final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       String? userEmail = googleUser?.email;
//       if (userEmail?.substring(userEmail.length - 7) != "tce.edu")

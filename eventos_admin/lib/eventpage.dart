// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, must_be_immutable, avoid_print

//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './img.dart';

class EventPage extends StatelessWidget {
  ///const EventPage({Key? key}) : super(key: key);

  String eventTitle;
  String eventDescription;
  String eventOrgV;
  String imageLink;
  String refe;
  int pageFrom;
  late double h;
  late double h1;
  String eventOrg;

  EventPage(
      {required this.eventTitle,
      required this.eventOrgV,
      required this.eventOrg,
      required this.imageLink,
      required this.refe,
      required this.eventDescription,
      required this.pageFrom});
  @override
  Widget build(BuildContext context) {
    if (pageFrom == 0) {
      h = 280;
      h1 = 90;
    } else {
      h = 230;
      h1 = 90;
    }
    return WillPopScope(
        onWillPop: () async {
          Navigator.maybePop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 255, 128, 24),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Event'),
          ),
          // appBar: AppBar(
          //   leading: IconButton(
          //     icon: Icon(Icons.arrow_back_ios),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          //   title: Text('Event'),
          // ),
          body: SlidingUpPanel(
            //defaultPanelState: PanelState.OPEN,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            color: Color.fromARGB(255, 240, 240, 240),
            minHeight: 250,
            maxHeight: 450,
            panel: Center(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.drag_handle_sharp),
                      //Text('Up'),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        height: h1,
                        child: Text(
                          eventTitle,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        //alignment: Alignment.centerLeft,
                        height: h,
                        child: ListView(
                          children: [
                            Text(
                              eventDescription,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  //fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   alignment: Alignment.centerRight,
                      //   height: 110,
                      //   child: Text(
                      //     'November - 8',
                      //     textAlign: TextAlign.left,
                      //     style: TextStyle(
                      //         fontSize: 15,
                      //         fontStyle: FontStyle.italic,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      if (pageFrom == 0) SlidingEventRegister(eventTitle),
                      if (pageFrom == 1)
                        SlidingEventRegisterViewer(
                            eventTitle: eventTitle,
                            refe: refe,
                            eventOrg: eventOrg,
                            eventOrgV: eventOrgV)
                    ],
                  ),
                ],
              ),
            ),
            body: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Poster(imageLink),
                ),
              ),
              child: Column(
                children: [Poster(imageLink)],
              ),
            ),
          ),
        ));
  }
}

class SlidingEventRegister extends StatelessWidget {
  //const SlidingEventRegister({Key? key}) : super(key: key);
  String eventTitle;
  SlidingEventRegister(this.eventTitle);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[RegisterButton(eventTitle)],
    );
    //);
  }
}

class RegisterButton extends StatelessWidget {
  //const RegisterButton({super.key});
  String eventTitle;

  final user = FirebaseAuth.instance.currentUser;
  final nameCon = TextEditingController();
  final regCon = TextEditingController();
  final deptCon = TextEditingController();
  RegisterButton(this.eventTitle);
  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.ref(eventTitle.toString());
    final dbRefProfile = FirebaseDatabase.instance.ref(user!.email);
    // print('${user!.email.toString()} ');
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 255, 128, 24)),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('You want to Register to this event?'),
          content: Column(
            children: [
              Text(eventTitle),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: nameCon,
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Regester number(Eg. 20C079)'),
                controller: regCon,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Department'),
                controller: deptCon,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                dbRef.child(regCon.text.toString()).set({
                  'Name': nameCon.text.toString(),
                  'Department': deptCon.text.toString(),
                  'Regno': regCon.text.toString(),
                  'email': user!.email.toString()
                });
                dbRefProfile
                    .child(regCon.text.toString())
                    .set({'Event': eventTitle.toString()});

                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Register'),
    );
  }
}

class SlidingEventRegisterViewer extends StatelessWidget {
  //const SlidingEventRegister({Key? key}) : super(key: key);
  String eventTitle;
  String refe;
  String eventOrg;
  String eventOrgV;
  SlidingEventRegisterViewer(
      {required this.eventTitle,
      required this.eventOrgV,
      required this.refe,
      required this.eventOrg});
  final databaseRef = FirebaseDatabase.instance.ref('Events');

  // if (eventof == 1) {
  //     eventOrg = 'CSI Asssociation';
  //   } else if (eventof == 2) {
  //     eventOrg = 'IE Association';
  //   }else if (eventof == 3) {
  //     eventOrg = 'GLUGOT TCE';
  //   }else if (eventof == 4) {
  //     eventOrg = 'IT';
  //   }else if (eventof == 5) {
  //     eventOrg = 'MECH';
  //   }else if (eventof == 6) {
  //     eventOrg = 'SPORTS';
  //   }else if (eventof == 7) {
  //     eventOrg = 'COLLEGE';
  //   }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ViewerButton(eventTitle),
        TextButton(
            onPressed: () {
              if (eventOrg == eventOrgV) {
                databaseRef
                    //.child(path)
                    .child(refe)
                    // .child(eventOrg)
                    .remove();
                Navigator.pop(context);
              }
            },
            child: Text('Delete Event'))
      ],
    );
    //);
  }
}

class ViewerButton extends StatelessWidget {
  //const RegisterButton({super.key});
  String eventTitle;
  ViewerButton(this.eventTitle);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 255, 128, 24)),
      // ignore: avoid_returning_null_for_void
      onPressed: (() => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrationPage(eventTitle)),
          )),
      child: const Text('View Registerations'),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  //const RegistrationPage({Key? key}) : super(key: key);
  String eventTitle;

  RegistrationPage(this.eventTitle);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int regCount = 0;

  // void increment() {
  //   setState(() {
  //     regCount++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final fRef = FirebaseDatabase.instance.ref(widget.eventTitle.toString());
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 128, 24),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Total Registrations: $regCount')),
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
            query: fRef,
            defaultChild: Center(child: Text('Loading...')),
            itemBuilder: (context, snapshot, animation, index) {
              // increment();
              return ListTile(
                leading: Text(snapshot.child('Department').value.toString()),
                title: Text(
                    '${snapshot.child('Name').value.toString()} ${snapshot.child('Regno').value.toString()}'),
                subtitle:
                    Text('Email: ${snapshot.child('email').value.toString()}'),
              );
            },
          ))
        ],
      ),
    );
  }
}

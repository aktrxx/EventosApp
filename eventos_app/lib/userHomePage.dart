//import 'package:eventos/loginpage.dart';
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventos/ProfileAdd.dart';
import 'package:eventos/profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './EventBox.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:firebase_database/firebase_database.dart';

import 'google_sign_in.dart';

class UserHomePage extends StatefulWidget {
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  // final user = FirebaseAuth.instance.currentUser!;

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Events');
  Future<int> alreadyExist(String name) async {
    print("\n\n\n\n\n");
    print(name);
    DocumentSnapshot<Map<String, dynamic>> result =
        await FirebaseFirestore.instance.collection('users').doc(name).get();

    if (result.exists) {
      print('yes');
      return 1;
    } else {
      print("no");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? emailof = user?.email;
    print("\n\n\n\n\n");
    print(emailof);
    return FutureBuilder<int>(
        future: alreadyExist(emailof!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int prof = snapshot.data!;
            return prof == 0
                ? AddProfile()
                : Center(
                    child: Scaffold(
                    // gradient: LinearGradient(
                    //   begin: Alignment.bottomLeft,
                    //   end: Alignment.topRight,
                    //   colors: const [
                    //     Color(0xFF8EC5FC),
                    //     Color(0xFFE0C3FC),
                    //   ],
                    // ),
                    drawer: Drawer(
                        backgroundColor: Color.fromARGB(255, 205, 226, 255),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 255, 128, 24),
                              Color.fromARGB(255, 255, 255, 255)
                            ],
                          )),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(user!.photoURL!),
                              ),
                              Text(
                                'User Name : ${user.displayName!.toUpperCase()}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                'Email : ${user.email!}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                              Container(
                                  child: Column(
                                children: [
                                  Text(
                                    'Events Participated',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  ListTile(
                                    title: Text('Event 1'),
                                  ),
                                ],
                              )),
                              Container(
                                  child: Column(
                                children: [
                                  Text(
                                    'Certificates',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  ListTile(
                                      title: Text('Event 1'),
                                      subtitle: Text('Download now')),
                                ],
                              )),
                              TextButton(
                                  onPressed: () {
                                    final provider =
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    provider.logout();
                                    //       Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => LoginPage()),
                                    // );

                                    //Navigator.pop(context);
                                  },
                                  child: Text('Logout')),
                              TextButton(
                                  onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddProfile()),
                                      ),
                                  child: Text("New Page"))
                            ],
                          )),
                        )),
                    appBar: AppBar(
                      backgroundColor: Color.fromARGB(255, 255, 128, 24),
                      title: Text("Eventos"),

                      // leading: GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => ProfilePage()),
                      //     );
                      //   },
                      //   child: Icon(
                      //     Icons.account_circle_rounded,
                      //     color: Colors.black,
                      //     size: 36, // add custom icons also
                      //   ),
                      // ),
                    ),

                    //  EventBox(
                    //     pageFrom: 0,
                    //     titleText: eventTitle,
                    //     descrText: 'lorem ipsum',
                    //     imageLink:
                    //         'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
                    //     dateTime: DateTime.now())

                    body: Column(
                      children: [
                        Expanded(
                            child: FirebaseAnimatedList(
                          //reverse: true,
                          query: ref,
                          defaultChild: Center(child: Text('Loading...')),
                          itemBuilder: (context, snapshot, animation, index) {
                            return EventBox(
                                eventOrgV:
                                    snapshot.child('eventOrg').value.toString(),
                                eventOrg:
                                    snapshot.child('eventOrg').value.toString(),
                                titleText:
                                    snapshot.child('Title').value.toString(),
                                descrText: snapshot
                                    .child('Description')
                                    .value
                                    .toString(),
                                dateTime:
                                    '${snapshot.child('Date').value.toString()} \n${snapshot.child('Time').value.toString()}',
                                imageLink:
                                    snapshot.child('Poster').value.toString(),
                                refe: snapshot.child('refe').value.toString(),
                                pageFrom: 0);
                          },
                        ))
                      ],
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 226, 226),

                    // floatingActionButton: FloatingActionButton(onPressed: () {
                    //       Navigator.push(  'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw'
                    //         context,
                    //         MaterialPageRoute(builder: (context) => const ProfilePage()),
                    //       );
                    //     }, ),
                  ));
          } else
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.red), //Text('FKU'),
            );
        });
  }
}




// ListView(
//         padding: const EdgeInsets.all(10),
//         //clipBehavior: ,

//         addAutomaticKeepAlives: false,
//         cacheExtent: 100,
//         children: <Widget>[
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),

//             child: ,
//           ),
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),'

//             child: EventBox(
//                 pageFrom: 0,
//                 titleText: eventTitle2,
//                 descrText: 'lorem ipsum',
//                 imageLink:
//                     'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
//                 dateTime: DateTime.now()),
//           ),
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),

//             child: EventBox(
//                 pageFrom: 0,
//                 titleText: eventTitle1,
//                 descrText: 'lorem ipsum',
//                 imageLink:
//                     'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
//                 dateTime: DateTime.now()),
//           ),
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),

//             child: EventBox(
//                 pageFrom: 0,
//                 titleText: eventTitle3,
//                 descrText: 'lorem ipsum',
//                 imageLink:
//                     'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
//                 dateTime: DateTime.now()),
//           ),
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),

//             child: EventBox(
//                 pageFrom: 0,
//                 titleText: eventTitle4,
//                 descrText: 'lorem ipsum',
//                 imageLink:
//                     'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
//                 dateTime: DateTime.now()),
//           ),
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),

//             child: EventBox(
//                 pageFrom: 0,
//                 titleText: eventTitle5,
//                 descrText: 'lorem ipsum',
//                 imageLink:
//                     'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
//                 dateTime: DateTime.now()),
//           ),
//           Container(
//             //  onTap: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => EventPage()),
//             //   ),

//             child: EventBox(
//                 pageFrom: 0,
//                 titleText: eventTitle6,
//                 descrText: 'lorem ipsum',
//                 imageLink:
//                     'https://drive.google.com/uc?export=view&id=1lmr5_2RzouXnIHYTZOcAQDThtxQzczuw',
//                 dateTime: DateTime.now()),
//           ),
//           // Container(
//           //     child: Column(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [
//           //     Text('Signed In as', style: TextStyle(fontSize: 16)),
//           //     SizedBox(height: 8),
//           //     Text(user.email!, style: TextStyle(fontSize: 20)),
//           //     SizedBox(height: 40),
//           //     ElevatedButton.icon(
//           //       style: ElevatedButton.styleFrom(
//           //         minimumSize: Size.fromHeight(50),
//           //       ),
//           //       icon: Icon(Icons.arrow_back, size: 32),
//           //       label: Text(
//           //         'Sign Out',
//           //         style: TextStyle(fontSize: 24),
//           //       ),
//           //       onPressed: () => FirebaseAuth.instance.signOut(),
//           //     ),
//           //   ],
//           // ))
//         ],
//       ),
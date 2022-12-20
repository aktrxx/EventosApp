// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_key_in_widget_constructors

// import 'dart:io';
// import 'dart:ui';

//import 'package:eventos/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

///import 'package:flutter/foundation.dart';
//import 'package:flutter/services.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:pat_provider/path_provider.dart';

class EventAddPage extends StatefulWidget {
  //final Storage storage;
  // const EventAddPage({
  //   Key? key,
  // }) : super(key: key);
  late String eventOrg;

  EventAddPage(this.eventOrg);

  @override
  State<EventAddPage> createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  // File? image;
  TextEditingController controller = TextEditingController();
  //late String state;
  //late Future<Directory> _appDocDir;

  // void initState() {
  //   super.initState();
  //   widget.storage.readData().then((String value) {
  //     setState(() {
  //       state = value;
  //     });
  //   });
  // }

  // Future<File> writeData() async {
  //   setState(() {
  //     state = controller.text;
  //     controller.text = '';
  //   });

  //   return widget.storage.writeData(state);
  // }

  // void getAppDirectory() {
  //   setState(() {
  //     _appDocDir = getApplicationDocumentsDirectory();
  //   });
  // }

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  //     if (image == null) return;

  //     final imageTemp = File(image.path);

  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  ///
  ///\
  ///
  ///
  ///
  ///
  ///
  // Future pickImageC() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.camera);

  //     if (image == null) return;

  //     final imageTemp = File(image.path);

  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     // ignore: avoid_print
  //     print('Failed to pick image: $e');
  //   }
  // }
  ///*/*
  ///knlkn
  ///lj l
  ///;kn;n
  ///
  ////
  ///
  ///
  // Color imgBox() {
  //   return image != null
  //       ? Color.fromARGB(255, 250, 250, 250)
  //       : Color.fromARGB(168, 194, 185, 185);
  // }

  bool loading = false;
  final postControllerTitle = TextEditingController();
  final postImageLinkController = TextEditingController();
  final postControllerDescription = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Events');
  final databaseFirestore = FirebaseFirestore.instance.collection('Events');

  DateTime date = DateTime(2022, 12, 24);
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt 
    = DateTime.now();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.light,
      home: Scaffold(
          //resizeToAvoidBottomInset: true,

          //resizeToAvoidBottomInset: true
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 169, 5, 51),
            title: Text("Add an Event!"),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 36, // add custom icons also
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Row(
                //   children: <Widget>[
                //     Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       child: Container(
                //           height: 200,
                //           width: 130,
                //           color: imgBox(),
                //           child: Center(
                //               child: image != null
                //                   ? Image.file(image!)
                //                   : Text(
                //                       "No image selected",
                //                       textAlign: TextAlign.center,
                //                     ))),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: ElevatedButton(
                //           onPressed: pickImage,
                //           style: ElevatedButton.styleFrom(
                //               primary: Color.fromARGB(255, 169, 5, 51)),
                //           child: Text('Pick Image from gallery')),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: TextField(
                      controller: postControllerTitle,
                      decoration: InputDecoration(labelText: 'Title'),
                      textAlign: TextAlign.start,
                      cursorHeight: 30,
                      cursorColor: Colors.black,
                      cursorWidth: 3),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: TextField(
                      controller: postControllerDescription,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(labelText: 'Decription'),
                      textAlign: TextAlign.start,
                      cursorHeight: 30,
                      cursorColor: Colors.black,
                      cursorWidth: 3),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: TextField(
                      controller: postImageLinkController,
                      //keyboardType: TextInputType.multiline,
                      //maxLines: null,
                      decoration:
                          InputDecoration(labelText: 'Event Poster Drive link'),
                      textAlign: TextAlign.start,
                      cursorHeight: 30,
                      cursorColor: Colors.black,
                      cursorWidth: 3),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${date.year}/${date.month}/${date.day}',
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(padding: ),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100));
                            if (newDate == null) return;
                            setState(() {
                              date = newDate;
                            });
                          },
                          child: Text('Select Date for an Event')),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(_timeOfDay.format(context).toString()),
                    SizedBox(
                      width: 60,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(padding: ),
                          onPressed: _showTimePicker,
                          child: Text('Select Time of an Event')),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 169, 5, 51)),
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          databaseRef
                              .child(dt.millisecondsSinceEpoch
                                  .toString())
                              .set({
                            'Title': postControllerTitle.text.toString(),
                            'Description':
                                postControllerDescription.text.toString(),
                            'Poster': postImageLinkController.text.toString(),
                            'Date': '${date.year}/${date.month}/${date.day}',
                            'Time': _timeOfDay.format(context), //.toString(),
                            'eventOrg': widget.eventOrg,
                            'refe':
                                dt.millisecondsSinceEpoch.toString()
                          });
                          Navigator.pop(context);
                        },
                        child: Text('POST EVENT')),
                  ),
                ),
              ],
            ),
          )),
      // ),
    );
  }
}

// class Storage {
//   Future<String> get localPath async {
//     final dir = await getApplicationDocumentsDirectory();
//     return dir.path;
//   }

//   Future<File> get localFile async {
//     final path = await localPath;
//     return File('$path/db.txt');
//   }

//   Future<String> readData() async {
//     try {
//       final file = await localFile;
//       String body = await file.readAsString();

//       return body;
//     } catch (e) {
//       return e.toString();final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
// String? userEmail = googleUser?.email;
// if (userEmail?.substring(userEmail.length - 7) != "tce.edu")
//     }
//   }

//   Future<File> writeData(String data) async {
//     final file = await localFile;
//     return file.writeAsString("$data");
//   }
// }

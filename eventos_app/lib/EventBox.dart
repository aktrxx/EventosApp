// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, use_key_in_widget_constructors, must_be_immutable, empty_constructor_bodies, annotate_overrides, file_names

//import 'package:flutter/cupertino.dart';
import 'package:eventos/eventpage.dart';
import 'package:flutter/material.dart';
import './img.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class EventBox extends StatelessWidget {
  //const EventBox({Key? key}) : super(key: key);
  String titleText;
  String descrText = '';
  int pageFrom;
  String dateTime;
  String imageLink;
  String eventOrgV;
  //late int eventof;
  late String eventOrg;
  String refe;
  @override
  EventBox(
      {required this.eventOrg,
      required this.eventOrgV,
      required this.refe,
      required this.titleText,
      required this.descrText,
      required this.dateTime,
      required this.imageLink,
      required this.pageFrom});

  Widget build(BuildContext context) {
    //AssetImage assetImage = AssetImage('images/artificial.png');
    //Image image = Image(image: assetImage);
    // if (eventof == 1) {
    //   eventOrg = 'CSI Asssociation';
    // } else if (eventof == 2) {
    //   eventOrg = 'IE Association';
    // }else if (eventof == 3) {
    //   eventOrg = 'GLUGOT TCE';
    // }else if (eventof == 4) {
    //   eventOrg = 'IT';
    // }else if (eventof == 5) {
    //   eventOrg = 'MECH';
    // }else if (eventof == 6) {
    //   eventOrg = 'SPORTS';
    // }else if (eventof == 7) {
    //   eventOrg = 'COLLEGE';
    // }
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventPage(
                  refe: refe,
                  eventOrg: eventOrg,
                  eventDescription: descrText,
                  pageFrom: pageFrom,
                  imageLink: imageLink,
                  eventTitle: titleText,
                  eventOrgV: eventOrgV
                )),
      ),
      child: Container(
        //  decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [
        //         Colors.blue,
        //         Colors.re
        //       ],
        //     )
        //   ),
        height: 200,
        child: InkWell(
          // onTap: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => EventPage()),
          //       ),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color.fromARGB(255, 255, 255, 255),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  )),
              padding: EdgeInsets.all(10),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 120, child: Poster(imageLink)),
                  SizedBox(
                    width: 200,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 70,
                            child: Text(
                              titleText,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            eventOrg,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(dateTime),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 30, top: 20),
                        //   child: Text(descrText, overflow: TextOverflow.fade),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(),
                        //   child: Text(dateTime.toString()),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

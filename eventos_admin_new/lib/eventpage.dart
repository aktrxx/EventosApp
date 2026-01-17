// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './img.dart';

class EventPage extends StatelessWidget {
  String eventTitle;
  String eventDescription;
  String eventOrgV;
  String imageLink;
  String refe;
  int pageFrom;
  late double h;
  late double h1;
  String eventOrg;

  EventPage({
    required this.eventTitle,
    required this.eventOrgV,
    required this.eventOrg,
    required this.imageLink,
    required this.refe,
    required this.eventDescription,
    required this.pageFrom,
  });

  @override
  Widget build(BuildContext context) {
    if (pageFrom == 0) {
      h = 280;
      h1 = 90;
    } else {
      h = 230;
      h1 = 90;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 128, 24),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Event Details'),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        color: Color.fromARGB(255, 240, 240, 240),
        minHeight: 250,
        maxHeight: 450,
        panel: Center(
          child: Column(
            children: [
              Icon(Icons.drag_handle_sharp),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: h,
                child: ListView(
                  children: [
                    Text(
                      eventDescription,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.business, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Organized by: $eventOrg',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (pageFrom == 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add to calendar or register
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Event registration coming soon'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text('Add to Calendar'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: Color.fromARGB(255, 255, 128, 24),
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 200, 150),
                Color.fromARGB(255, 255, 240, 230),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: imageLink.isNotEmpty
                  ? Poster(imageLink)
                  : Container(
                      width: 300,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 80, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'No Poster Available',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

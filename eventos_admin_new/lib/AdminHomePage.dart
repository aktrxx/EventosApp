// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:eventos_admin_new/eventadd.dart';
import 'package:flutter/material.dart';
import 'EventBox.dart';

class AdminHome extends StatelessWidget {
  int eventof;

  AdminHome(this.eventof);
  static String routeName = '/admin_page';

  @override
  Widget build(BuildContext context) {
    return AddEvent(eventof);
  }
}

class AddEvent extends StatelessWidget {
  int eventof;
  late String eventOrg;
  
  AddEvent(this.eventof);

  @override
  Widget build(BuildContext context) {
    // Set event organization based on eventof
    if (eventof == 1) {
      eventOrg = 'CSI Association';
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
    } else {
      eventOrg = 'Admin';
    }

    return Scaffold(
      appBar: AppBar(
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
                mainAxisSize: MainAxisSize.min,
                children: [Text('Logout as Admin')],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Icon(
            Icons.account_circle_rounded,
            color: Colors.black,
            size: 36,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Organization: $eventOrg',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No events yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add an event using the + button',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 220, 133, 194),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 169, 5, 51),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventAddPage(eventOrg),
          ),
        ),
        label: Text('Add an Event'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

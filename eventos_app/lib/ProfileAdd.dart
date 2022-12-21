// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventos/userHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

const List<String> list = <String>[
  'CSE',
  'IT',
  'ECE',
  'CIVIL',
  'MECH',
  'MECT',
  'CSBS'
];
String dropdownValue = list.first; //= 'Select';

class AddProfile extends StatelessWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 215, 215),
      body: //SingleChildScrollView(
          //child:
          Center(
              child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 300,
                child:
                    TextField(decoration: InputDecoration(labelText: 'Name'))),
            SizedBox(
                width: 300,
                child: TextField(
                    decoration: InputDecoration(labelText: 'Register number'))),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Department :      '),
                  DropdownButtonExample(),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserHomePage()));
                },
                child: Text("RETURN"))
          ],
        ),
      )),
      //  ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  // widget.dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

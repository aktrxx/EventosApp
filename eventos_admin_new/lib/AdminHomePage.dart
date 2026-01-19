// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:eventos_admin_new/eventadd.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'EventBox.dart';

class AdminHome extends StatelessWidget {
  final int eventof;

  AdminHome(this.eventof);
  static String routeName = '/admin_page';

  @override
  Widget build(BuildContext context) {
    return AddEvent(eventof);
  }
}

class AddEvent extends StatefulWidget {
  final int eventof;

  AddEvent(this.eventof);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late String eventOrg;
  late String eventOrgCode;
  List<dynamic> events = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setOrganization();
    _fetchEvents();
  }

  void _setOrganization() {
    // Set event organization based on eventof
    if (widget.eventof == 1) {
      eventOrg = 'CSI Association';
      eventOrgCode = 'CSI';
    } else if (widget.eventof == 2) {
      eventOrg = 'IE Association';
      eventOrgCode = 'IE';
    } else if (widget.eventof == 3) {
      eventOrg = 'GLUGOT TCE';
      eventOrgCode = 'GLUGOT';
    } else if (widget.eventof == 4) {
      eventOrg = 'IT';
      eventOrgCode = 'IT';
    } else if (widget.eventof == 5) {
      eventOrg = 'MECH';
      eventOrgCode = 'MECH';
    } else if (widget.eventof == 6) {
      eventOrg = 'SPORTS';
      eventOrgCode = 'SPORTS';
    } else if (widget.eventof == 7) {
      eventOrg = 'COLLEGE';
      eventOrgCode = 'COLLEGE';
    } else {
      eventOrg = 'Admin';
      eventOrgCode = 'ADMIN';
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Get JWT token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Session expired';
        });
        return;
      }

      // API call to fetch events
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/events/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          events = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load events';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Connection error: $e';
      });
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 169, 5, 51),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text("Eventos Admin", style: TextStyle(fontSize: 22)),
        leading: GestureDetector(
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Logout?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Are you sure you want to logout?')],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleLogout();
                  },
                  child: const Text('Logout'),
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchEvents,
            tooltip: 'Refresh',
          ),
        ],
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          errorMessage,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchEvents,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : events.isEmpty
                ? Center(
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
                  )
                : RefreshIndicator(
                    onRefresh: _fetchEvents,
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventBox(
                          eventOrg: event['organization'] ?? '',
                          eventOrgV: event['organization_display'] ?? '',
                          refe: event['id'].toString(),
                          titleText: event['title'] ?? '',
                          descrText: event['description'] ?? '',
                          dateTime: '${event['date']} ${event['time']}',
                          imageLink: event['poster_image'] ?? '',
                          pageFrom: widget.eventof,
                          venue: event['venue'] ?? '',
                          createdBy: event['created_by_name'] ?? '',
                          onEventDeleted: _fetchEvents,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 220, 133, 194),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 169, 5, 51),
        onPressed: () async {
          // Navigate and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventAddPage(eventOrg)),
          );

          // If event was created, refresh the list
          if (result == true) {
            _fetchEvents();
          }
        },
        label: Text('Add an Event'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

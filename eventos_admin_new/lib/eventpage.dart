// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'dart:convert';
import 'package:eventos_admin_new/eventedit.dart';
import 'package:eventos_admin_new/tempAdminLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import './img.dart';

class EventPage extends StatefulWidget {
  String eventTitle;
  String eventDescription;
  String eventOrgV;
  String imageLink;
  String refe;
  int pageFrom;
  String eventOrg;
  String? dateTime;
  String? venue;

  EventPage({
    required this.eventTitle,
    required this.eventOrgV,
    required this.eventOrg,
    required this.imageLink,
    required this.refe,
    required this.eventDescription,
    required this.pageFrom,
    this.dateTime,
    this.venue,
  });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isDeleting = false;
  late double h;
  late double h1;

  Future<void> _navigateToEdit() async {
    // Parse date and time from dateTime string
    String? date;
    String? time;

    if (widget.dateTime != null) {
      final parts = widget.dateTime!.split(' ');
      if (parts.length >= 2) {
        date = parts[0]; // YYYY-MM-DD
        time = parts[1]; // HH:MM:SS
      }
    }

    // Prepare event data
    Map<String, dynamic> eventData = {
      'title': widget.eventTitle,
      'description': widget.eventDescription,
      'date': date,
      'time': time,
      'venue': widget.venue ?? '',
    };

    // Navigate to edit page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          eventId: widget.refe,
          eventOrg: widget.eventOrgV,
          eventData: eventData,
        ),
      ),
    );

    // If event was updated, go back with refresh flag
    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteEvent() async {
    // Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text(
          'Are you sure you want to delete "${widget.eventTitle}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      isDeleting = true;
    });

    try {
      // Get JWT token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(body: TempLoginWidget()),
          ),
          (route) => false,
        );
        return;
      }

      // API call to delete event
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/events/${widget.refe}/delete/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      setState(() {
        isDeleting = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Go back to previous page with refresh flag
        Navigator.pop(context, true);
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to delete event'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageFrom == 0) {
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
                  widget.eventTitle,
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
                      widget.eventDescription,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.business, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Organized by: ${widget.eventOrg}',
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
              if (widget.pageFrom == 0)
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
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isDeleting ? null : _navigateToEdit,
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 45),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isDeleting ? null : _deleteEvent,
                          icon: isDeleting
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Icon(Icons.delete),
                          label: Text(isDeleting ? 'Deleting...' : 'Delete'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 45),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
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
              child: widget.imageLink.isNotEmpty
                  ? Poster(widget.imageLink)
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

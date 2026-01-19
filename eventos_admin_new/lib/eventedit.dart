// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventEditPage extends StatefulWidget {
  final String eventId;
  final String eventOrg;
  final Map<String, dynamic> eventData;

  EventEditPage({
    required this.eventId,
    required this.eventOrg,
    required this.eventData,
  });

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController venueController;

  // For API date/time format
  String? apiDate;
  String? apiTime;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    titleController = TextEditingController(
      text: widget.eventData['title'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.eventData['description'] ?? '',
    );
    venueController = TextEditingController(
      text: widget.eventData['venue'] ?? '',
    );

    // Parse and set existing date
    if (widget.eventData['date'] != null) {
      try {
        final dateParts = widget.eventData['date'].split('-');
        if (dateParts.length == 3) {
          final year = dateParts[0];
          final month = dateParts[1];
          final day = dateParts[2];
          dateController = TextEditingController(text: "$day/$month/$year");
          apiDate = widget.eventData['date']; // Keep original format
        }
      } catch (e) {
        dateController = TextEditingController();
      }
    } else {
      dateController = TextEditingController();
    }

    // Parse and set existing time
    if (widget.eventData['time'] != null) {
      try {
        final timeParts = widget.eventData['time'].split(':');
        if (timeParts.length >= 2) {
          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);

          // Convert to 12-hour format for display
          String period = hour >= 12 ? 'PM' : 'AM';
          if (hour > 12) hour -= 12;
          if (hour == 0) hour = 12;

          timeController = TextEditingController(
            text:
                "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period",
          );
          apiTime = widget.eventData['time']; // Keep original format
        }
      } catch (e) {
        timeController = TextEditingController();
      }
    } else {
      timeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    venueController.dispose();
    super.dispose();
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      if (apiDate == null || apiTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select both date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
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
          Navigator.popUntil(context, (route) => route.isFirst);
          return;
        }

        // API call to update event
        final response = await http.put(
          Uri.parse(
            'http://10.0.2.2:8000/api/events/${widget.eventId}/update/',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'title': titleController.text.trim(),
            'description': descriptionController.text.trim(),
            'date': apiDate,
            'time': apiTime,
            'venue': venueController.text.trim(),
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Event updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Go back with success flag
          Navigator.pop(context, true);
        } else {
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to update event'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 169, 5, 51),
        title: Text('Edit Event'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 220, 133, 194),
              Color.fromARGB(255, 240, 180, 220),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Organization Display
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: Color.fromARGB(255, 169, 5, 51),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Organization: ${widget.eventOrg}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Info card
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Organization cannot be changed after creation',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Event Title
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Date
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: apiDate != null
                          ? DateTime.parse(apiDate!)
                          : DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      // Display format
                      dateController.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                      // API format (YYYY-MM-DD)
                      apiDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
                SizedBox(height: 16),

                // Time
                TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select time';
                    }
                    return null;
                  },
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: apiTime != null
                          ? TimeOfDay(
                              hour: int.parse(apiTime!.split(':')[0]),
                              minute: int.parse(apiTime!.split(':')[1]),
                            )
                          : TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      // Display format
                      timeController.text = pickedTime.format(context);
                      // API format (HH:MM:SS)
                      apiTime =
                          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00";
                    }
                  },
                ),
                SizedBox(height: 16),

                // Venue
                TextFormField(
                  controller: venueController,
                  decoration: InputDecoration(
                    labelText: 'Venue',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter venue';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _updateEvent,
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(Icons.save),
                    label: Text(
                      _isLoading ? 'Updating...' : 'Update Event',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 169, 5, 51),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

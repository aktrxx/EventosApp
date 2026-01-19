// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:eventos_admin_new/AdminHomePage.dart';
import 'package:eventos_admin_new/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TempLoginWidget extends StatefulWidget {
  const TempLoginWidget({super.key});

  @override
  _TempLoginWidgetState createState() => _TempLoginWidgetState();
}

class _TempLoginWidgetState extends State<TempLoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Map organization name to eventof index
  int _getEventofIndex(String organization) {
    switch (organization) {
      case 'CSI':
        return 1;
      case 'IE':
        return 2;
      case 'GLUGOT':
        return 3;
      case 'IT':
        return 4;
      case 'MECH':
        return 5;
      case 'SPORTS':
        return 6;
      case 'COLLEGE':
        return 7;
      default:
        return 0; // admin or unknown
    }
  }

  // Login API call
  Future<void> _handleLogin() async {
    String username = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validation
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both username and password'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // API call to Django backend
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Parse response
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // Save JWT tokens
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'access_token',
            data['data']['tokens']['access'],
          );
          await prefs.setString(
            'refresh_token',
            data['data']['tokens']['refresh'],
          );
          await prefs.setString('username', data['data']['user']['username']);
          await prefs.setString(
            'organization',
            data['data']['user']['organization'],
          );

          // Get organization index
          String organization = data['data']['user']['organization'];
          int eventofIndex = _getEventofIndex(organization);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login successful! Welcome ${data['data']['user']['first_name']}',
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome(eventofIndex)),
          );
        } else {
          // Show error from backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Login failed'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Parse error response
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Invalid credentials'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Network or other error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 169, 5, 51),
          Color.fromARGB(255, 220, 133, 194),
        ],
      ),
    ),
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Title
              Icon(Icons.event_note, size: 100, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Eventos Admin',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Event Management System',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 48),

              // Username TextField
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
              SizedBox(height: 16),

              // Password TextField
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.lock, color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
              ),
              SizedBox(height: 32),
              // Sign In Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(56),
                  backgroundColor: Colors.white,
                  foregroundColor: Color.fromARGB(255, 169, 5, 51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 169, 5, 51),
                          ),
                        ),
                      )
                    : Icon(Icons.login, size: 28),
                label: Text(
                  _isLoading ? 'Signing In...' : 'Sign In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: _isLoading ? null : _handleLogin,
              ),
              SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

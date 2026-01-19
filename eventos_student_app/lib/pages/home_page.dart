// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:eventos_user_app/pages/events_list_page.dart';
import 'package:eventos_user_app/pages/my_registrations_page.dart';
import 'package:eventos_user_app/pages/profile_page.dart';
import 'package:eventos_user_app/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    MyRegistrationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<OrganizationCategory> organizations = [
    OrganizationCategory(
      name: 'CSI Association',
      code: 'CSI',
      icon: Icons.computer,
      color: Color(0xFF2196F3),
    ),
    OrganizationCategory(
      name: 'IE Association',
      code: 'IE',
      icon: Icons.engineering,
      color: Color(0xFFFF9800),
    ),
    OrganizationCategory(
      name: 'GLUGOT TCE',
      code: 'GLUGOT',
      icon: Icons.code,
      color: Color(0xFF4CAF50),
    ),
    OrganizationCategory(
      name: 'IT Department',
      code: 'IT',
      icon: Icons.laptop,
      color: Color(0xFF9C27B0),
    ),
    OrganizationCategory(
      name: 'MECH Department',
      code: 'MECH',
      icon: Icons.build,
      color: Color(0xFFF44336),
    ),
    OrganizationCategory(
      name: 'Sports',
      code: 'SPORTS',
      icon: Icons.sports_cricket,
      color: Color(0xFF00BCD4),
    ),
    OrganizationCategory(
      name: 'College Events',
      code: 'COLLEGE',
      icon: Icons.school,
      color: Color(0xFF3F51B5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryLight, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Discover events around you',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Organization Categories
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Event Categories',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: organizations.length,
                        itemBuilder: (context, index) {
                          final org = organizations[index];
                          return OrganizationCard(organization: org);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrganizationCategory {
  final String name;
  final String code;
  final IconData icon;
  final Color color;

  OrganizationCategory({
    required this.name,
    required this.code,
    required this.icon,
    required this.color,
  });
}

class OrganizationCard extends StatelessWidget {
  final OrganizationCategory organization;

  const OrganizationCard({required this.organization});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventsListPage(
              organizationName: organization.name,
              organizationCode: organization.code,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              organization.color,
              organization.color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: organization.color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                organization.icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              organization.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

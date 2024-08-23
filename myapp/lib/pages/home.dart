import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth for authentication
  String? _selectedCourse;

  final List<String> _courses = [
    "Introduction to Computer Science",
    "Calculus I",
    "Introduction to Psychology",
    "Principles of Economics",
    "Organic Chemistry",
    "Data Structures and Algorithms",
    "World History",
    "English Literature",
    "Physics I",
    "Marketing Principles",
    "Web Development",
    "Microbiology",
    "Art History",
    "Environmental Science",
    "Business Law",
    "Sociology",
    "Human Anatomy",
    "Political Science",
    "Software Engineering",
    "Ethics in Technology",
  ];

  // Method to handle course registration
  void _registerCourse() async {
    if (_selectedCourse != null) {
      await _firestore.collection('registrations').add({
        'course': _selectedCourse,
        'studentId': 'sampleStudentId', // Replace with actual student ID
      });

      Navigator.pushNamed(context, '/courses');
    }
  }

  // Method to handle logout
  void _logout() async {
    try {
      await _auth.signOut(); // Sign out the current user
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page and replace the current route
    } catch (e) {
      // Handle logout error if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // Title of the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Icon for the logout button
            onPressed: _logout, // Call _logout method when pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the form
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '');
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.home),
                      Text('Home'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/courses');
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.book),
                      Text('Courses'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.person),
                      Text('Profile'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Space between the elements
            DropdownButton<String>(
              hint: const Text('Select a Course'), // Hint for the dropdown
              value: _selectedCourse, // Current selected value
              onChanged: (newValue) {
                setState(() {
                  _selectedCourse = newValue; // Update selected course
                });
              },
              items: _courses.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
            ),
            const SizedBox(height: 20), // Space between the elements
            ElevatedButton(
              onPressed: _registerCourse, // Call _registerCourse method on press
              child: const Text('Register'), // Button label
            ),
          ],
        ),
      ),
    );
  }
}

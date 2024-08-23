import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('registrations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data!.docs;

          if (courses.isEmpty) {
            return const Center(
              child: Text("You haven't registered any course yet."),
            );
          }

          return ListView(
            children: courses.map((course) {
              return ListTile(
                title: Text(course['course']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/courses.dart';
import 'package:myapp/pages/profile.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/signup.dart'; // Import your SignupPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAAOZz-P1JEJeFw_wmvVXDxbC2IsE08RCY",
      appId: "1:136198820190:android:490bad1193dee169f87fcf",
      messagingSenderId: "136198820190",
      projectId: "myapp-b8d6d",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Registration System',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.brown, // Use colorSchemeSeed for Material 3 color theming
        scaffoldBackgroundColor: Colors.white, // Setting a specific background color if needed
        appBarTheme: const 
        AppBarTheme(color: Colors.brown,),
      ),
      home: const AuthWrapper(),
      routes: {
        '/signup': (context) => SignUpPage(), // Define the signup route
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/courses': (context) => CoursesPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

// This widget checks the user's authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while waiting for authentication status
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // If the user is authenticated, show the home page
          return const HomePage();
        } else {
          // If the user is not authenticated, show the login page
          return const LoginPage();
        }
      },
    );
  }
}

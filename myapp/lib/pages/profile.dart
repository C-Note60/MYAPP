import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance; // Instance of FirebaseAuth for authentication
  final _profileFormKey = GlobalKey<FormState>(); // Key for profile form validation
  final _passwordFormKey = GlobalKey<FormState>(); // Key for password form validation

  String _email = ''; // Variable to store email
  String _displayName = ''; // Variable to store display name
  String _newPassword = ''; // Variable to store new password
  String _confirmPassword = ''; // Variable to store confirm password
  bool _isEditingProfile = false; // Boolean to toggle edit mode for profile
  bool _isEditingPassword = false; // Boolean to toggle edit mode for password

  @override
  void initState() {
    super.initState();
    // Initialize state with current user information
    _email = _auth.currentUser?.email ?? ''; // Get current user's email
    _displayName = _auth.currentUser?.displayName ?? ''; // Get current user's display name
  }

  Future<void> _updateProfile() async {
    if (_profileFormKey.currentState!.validate()) { // Validate the profile form
      try {
        User? user = _auth.currentUser; // Get the current user

        if (user != null) {
          // Update user's display name
          await user.updateProfile(displayName: _displayName);

          // Verify and update email if changed
          if (_email != user.email) {
            await user.verifyBeforeUpdateEmail(_email); // Send verification email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification email sent. Please check your email to confirm.')),
            );
          }

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          
          // Exit edit mode after saving changes
          setState(() {
            _isEditingProfile = false;
          });
        }
      } catch (e) {
        // Show error message if there is an issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _updatePassword() async {
    if (_passwordFormKey.currentState!.validate()) { // Validate the password form
      try {
        User? user = _auth.currentUser; // Get the current user

        if (user != null) {
          // Update password if provided and confirmed
          if (_newPassword.isNotEmpty && _newPassword == _confirmPassword) {
            await user.updatePassword(_newPassword); // Update password
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password updated successfully')),
            );
          } else if (_newPassword.isNotEmpty) {
            // Show error message if passwords do not match
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match')),
            );
          }
          
          // Exit edit mode after saving changes
          setState(() {
            _isEditingPassword = false;
          });
        }
      } catch (e) {
        // Show error message if there is an issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Title of the AppBar
        actions: [
          // Edit button to toggle between read-only and edit mode
          IconButton(
            icon: Icon(_isEditingProfile ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditingProfile = !_isEditingProfile; // Toggle the edit mode
                if (!_isEditingProfile) {
                  _updateProfile(); // Save changes when exiting edit mode
                }
              });
            },
          ),
          IconButton(
            icon: Icon(_isEditingPassword ? Icons.check : Icons.lock),
            onPressed: () {
              setState(() {
                _isEditingPassword = !_isEditingPassword; // Toggle the password edit mode
                if (!_isEditingPassword) {
                  _updatePassword(); // Save changes when exiting password edit mode
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
          children: [
            // Profile form
            _isEditingProfile
                ? Form(
                    key: _profileFormKey, // Key for profile form validation
                    child: Column(
                      children: [
                        // Text field for email input
                        TextFormField(
                          initialValue: _email, // Initial value of the email field
                          decoration: const InputDecoration(labelText: 'Email'), // Decoration for the text field
                          keyboardType: TextInputType.emailAddress, // Keyboard type for email input
                          onChanged: (value) => _email = value, // Update email variable on change
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email'; // Validation message for empty email
                            }
                            return null; // Return null if validation passes
                          },
                        ),
                        // Text field for display name input
                        TextFormField(
                          initialValue: _displayName, // Initial value of the display name field
                          decoration: const InputDecoration(labelText: 'Display Name'), // Decoration for the text field
                          onChanged: (value) => _displayName = value, // Update display name variable on change
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      // Display email with larger text
                      Text(
                        'Email: $_email',
                        style: const TextStyle(
                          fontSize: 20, // Increase font size
                          fontWeight: FontWeight.bold, // Make text bold
                        ),
                      ),
                      // Display display name with larger text
                      Text(
                        'Display Name: $_displayName',
                        style: const TextStyle(
                          fontSize: 20, // Increase font size
                          fontWeight: FontWeight.bold, // Make text bold
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 20), // Space between sections
            // Password form
            _isEditingPassword
                ? Form(
                    key: _passwordFormKey, // Key for password form validation
                    child: Column(
                      children: [
                        // Text field for new password input
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'New Password'), // Decoration for the text field
                          obscureText: true, // Hide password input
                          onChanged: (value) => _newPassword = value, // Update new password variable on change
                          validator: (value) {
                            if (value != null && value.length < 6) {
                              return 'Password must be at least 6 characters'; // Validation message for short password
                            }
                            return null; // Return null if validation passes
                          },
                        ),
                        // Text field for confirm password input
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Confirm Password'), // Decoration for the text field
                          obscureText: true, // Hide password input
                          onChanged: (value) => _confirmPassword = value, // Update confirm password variable on change
                          validator: (value) {
                            if (value != _newPassword) {
                              return 'Passwords do not match'; // Validation message for mismatched passwords
                            }
                            return null; // Return null if validation passes
                          },
                        ),
                      ],
                    ),
                  )
                : Container(), // Empty container if not editing password
          ],
        ),
      ),
    );
  }
}

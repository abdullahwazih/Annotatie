import 'package:annotatiev02/components/button.dart';
import 'package:annotatiev02/components/custom_texfield.dart';
import 'package:annotatiev02/components/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:annotatiev02/Auth/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String _selectedRole = 'user';

  // Dark blue theme colors
  final Color primaryColor = const Color(0xFF0D1A36); // Very dark blue
  final Color lightColor = const Color(0xFF1A237E); // Indigo[900]
  final Color darkColor = const Color(0xFF0A1124); // Even darker blue
  final Color cardColor = const Color(0xFF232F4B); // Card background
  final Color accentColor = const Color(0xFF42A5F5); // Blue accent

  void reg() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    String? result = await AuthService().signUp(
      email: emailController.text,
      password: passwordController.text,
      username: nameController.text,
      role: _selectedRole,
    );

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo or Title
                Icon(Icons.person_add_alt_1, size: 64, color: accentColor),
                const SizedBox(height: 12),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name Field
                CustomTexfield(
                  hintText: 'Full Name',
                  obsecureText: false,
                  controller: nameController,
                ),
                const SizedBox(height: 16),

                // Email Field
                CustomTexfield(
                  hintText: 'Email',
                  obsecureText: false,
                  controller: emailController,
                ),
                const SizedBox(height: 16),

                // Password Field
                CustomTexfield(
                  hintText: 'Password',
                  obsecureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                CustomTexfield(
                  hintText: 'Confirm Password',
                  obsecureText: true,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 24),

                // Role Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'user',
                          groupValue: _selectedRole,
                          activeColor: accentColor,
                          fillColor: MaterialStateProperty.all(accentColor),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        Text('User', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'admin',
                          groupValue: _selectedRole,
                          activeColor: accentColor,
                          fillColor: MaterialStateProperty.all(accentColor),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        Text(
                          'Annotator',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: reg,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(foregroundColor: accentColor),
                      child: const Text('Login'),
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
}

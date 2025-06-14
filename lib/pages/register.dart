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
  final TextEditingController nameController =
      TextEditingController(); // New controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String _selectedRole = 'user'; // default role

  void reg() async {
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    // Call AuthService to register
    String? result = await AuthService().signUp(
      email: emailController.text,
      password: passwordController.text,
      username: nameController.text, // Send name as username
      role: _selectedRole,
    );

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    } else {
      // Registration successful
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register Page',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Full Name Field
                CustomTexfield(
                  hintText: 'Full Name',
                  obsecureText: false,
                  controller: nameController,
                ),
                Sizedbox(),

                // Email Field
                CustomTexfield(
                  hintText: 'Email',
                  obsecureText: false,
                  controller: emailController,
                ),
                Sizedbox(),

                // Password Field
                CustomTexfield(
                  hintText: 'Password',
                  obsecureText: true,
                  controller: passwordController,
                ),
                Sizedbox(),

                // Confirm Password Field
                CustomTexfield(
                  hintText: 'Confirm Password',
                  obsecureText: true,
                  controller: confirmPasswordController,
                ),
                Sizedbox(),

                // Role Selection
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'user',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        const Text('User'),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'admin',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        const Text('Annotator'),
                      ],
                    ),
                  ],
                ),
                Sizedbox(),

                // Register Button
                Button(buttonText: 'Register', onPressed: reg),
                Sizedbox(),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
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

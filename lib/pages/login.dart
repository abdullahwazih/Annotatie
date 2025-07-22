import 'package:annotatiev02/Auth/auth_service.dart';
import 'package:annotatiev02/components/custom_texfield.dart';
import 'package:annotatiev02/components/sized_box.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Login({super.key});

  void login(BuildContext context) async {
    String? result = await AuthService().logIn(
      email: emailController.text,
      password: passwordController.text,
    );

    if (result == 'user') {
      Navigator.pushNamed(context, '/userHome');
    } else if (result == 'admin') {
      Navigator.pushNamed(context, '/annotatorHome');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dark blue theme colors
    final primaryColor = const Color(0xFF0A2342); // dark blue
    final accentColor = const Color(0xFF274690); // lighter blue
    final cardColor = const Color(0xFF1B2A49); // card background
    final bgGradient = LinearGradient(
      colors: [primaryColor.withOpacity(0.98), accentColor.withOpacity(0.98)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: cardColor,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App logo or illustration
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: accentColor.withOpacity(0.2),
                        child: Icon(
                          Icons.lock_outline,
                          size: 48,
                          color: accentColor,
                        ),
                      ),
                    ),
                    // Welcome text
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey[200],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomTexfield(
                      hintText: 'Email',
                      obsecureText: false,
                      controller: emailController,
                    ),
                    Sizedbox(height: 10),
                    CustomTexfield(
                      hintText: 'Password',
                      obsecureText: true,
                      controller: passwordController,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(160, 5, 0, 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blueGrey[200],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        onPressed: () => login(context),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.blueGrey[200]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

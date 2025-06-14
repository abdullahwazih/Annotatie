import 'package:annotatiev02/Auth/auth_service.dart';
import 'package:annotatiev02/components/button.dart';
import 'package:annotatiev02/components/custom_texfield.dart';
import 'package:annotatiev02/components/sized_box.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Login({super.key});

  void login(BuildContext context) async {
    // Call AuthService to log in
    String? result = await AuthService().logIn(
      email: emailController.text,
      password: passwordController.text,
    );

    if (result == 'user') {
      // Navigate to user home page
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/userHome');
    } else if (result == 'admin') {
      // Navigate to admin home page
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/annotatorHome');
    } else {
      // Show error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text(
                'Login Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTexfield(
                hintText: 'Email',
                obsecureText: false,
                controller: emailController,
              ),
              Sizedbox(),
              CustomTexfield(
                hintText: 'Password',
                obsecureText: true,
                controller: passwordController,
              ),
              Sizedbox(),
              Button(
                buttonText: 'Log In',
                onPressed: () => login(context),
              ), // ✅ Correct

              Sizedbox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

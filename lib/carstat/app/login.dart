import 'package:flutter/material.dart';
// import 'package:my_project/carstat/app/home_page.dart';
import 'package:my_project/carstat/app/register.dart';
import 'package:my_project/carstat/logic/services/authentication/authenication_service.dart';
import 'package:my_project/carstat/login_register/button.dart';
import 'package:my_project/carstat/login_register/screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final loggedIn = await _authService.login(email, password);

    if (mounted) {
      if (loggedIn) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSettings.init(
        context,); // Ensure to call this to initialize screen settings

    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(size: ScreenSettings.logoSize),
                SizedBox(height: ScreenSettings.spacing * 1.5),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: ScreenSettings.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: ScreenSettings.spacing),
                Padding(
                  padding: ScreenSettings.padding,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.deepPurple[50],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenSettings.spacing * 0.5),
                Padding(
                  padding: ScreenSettings.padding,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      // Corrected hint text
                      fillColor: Colors.deepPurple[50],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenSettings.spacing),
                ButtonWidget(
                  buttonText: 'Login',
                  onPressed:
                      _attemptLogin,
                ),
                SizedBox(height: ScreenSettings.spacing * 0.5),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

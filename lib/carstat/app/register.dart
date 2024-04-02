import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/carstat/bloc/user/user_bloc.dart';
import 'package:my_project/carstat/bloc/user/user_events.dart';
import 'package:my_project/carstat/bloc/user/user_states.dart';
import 'package:my_project/carstat/logic/services/authentication/authenication_service.dart';

import 'package:my_project/carstat/login_register/button.dart';
import 'package:my_project/carstat/login_register/screen.dart';
import 'package:my_project/carstat/login_register/text.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<UserBloc>().add(SignUpRequested(name, email, password));
  }

  @override
  Widget build(BuildContext context) {
    ScreenSettings.init(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserRegistrationSuccess) {
            Navigator.pushNamed(context, '/login');
          } else if (state is UserRegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: ScreenSettings.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: ScreenSettings.spacing * 2),
                  Padding(
                    padding: ScreenSettings.padding,
                    child: TextArea(
                      hintText: 'Username',
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Name cannot be empty' : null,
                    ),
                  ),
                  SizedBox(height: ScreenSettings.spacing * 0.5),
                  Padding(
                    padding: ScreenSettings.padding,
                    child: TextArea(
                      hintText: 'Email',
                      controller: _emailController,
                      validator: (value) =>
                          value!.length < 6 ? 'Password too short' : null,
                    ),
                  ),
                  SizedBox(height: ScreenSettings.spacing * 0.5),
                  Padding(
                    padding: ScreenSettings.padding,
                    child: TextArea(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) =>
                          value!.contains('@') ? null : 'Enter a valid email',
                    ),
                  ),
                  SizedBox(height: ScreenSettings.spacing),
                  ButtonWidget(
                    buttonText: 'Register',
                    onPressed: _attemptRegister,
                  ),
                  SizedBox(height: ScreenSettings.spacing * 0.5),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Already have an account? Login',
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
      ),
    );
  }
}

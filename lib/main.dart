import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/carstat/app/autologin_page.dart';
import 'package:my_project/carstat/app/home_page.dart';
import 'package:my_project/carstat/app/login.dart';
import 'package:my_project/carstat/app/profile.dart';
import 'package:my_project/carstat/app/register.dart';
import 'package:my_project/carstat/bloc/home/car_bloc.dart';
import 'package:my_project/carstat/bloc/user/user_bloc.dart';
import 'package:my_project/carstat/logic/services/authentication/authenication_service.dart';
import 'package:my_project/carstat/logic/services/car/car_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<CarService>(
          create: (_) => CarService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CarBloc>(
            create: (context) =>
                CarBloc(context.read<CarService>()),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(context.read<AuthService>()),
          ),
        ],
        child: MaterialApp(
          title: 'Fitness App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
            home: const AutologinPage(),
            routes: {
              '/home': (context) => const MainPage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegistrationPage(),
              '/profile': (context) => const UserProfilePage(),
            },
        ),
      ),
    );
  }
}

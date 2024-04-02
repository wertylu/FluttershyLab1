import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/carstat/bloc/user/user_bloc.dart';
import 'package:my_project/carstat/bloc/user/user_events.dart';
import 'package:my_project/carstat/bloc/user/user_states.dart';
import 'package:my_project/carstat/profile/screen.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                context.read<UserBloc>().add(Logout());
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUser());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        actions: [
          TextButton(
            onPressed: () => _showLogoutConfirmationDialog(context),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: ScreenProf.avatarRadius(context),
                        backgroundImage:
                            const AssetImage('assets/placeholder.png'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Name: ${state.user.name}',
                      style: TextStyle(
                        fontSize: ScreenProf.fontSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Email: ${state.user.email}',
                      style: TextStyle(
                        fontSize: ScreenProf.fontSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No user data available'));
        },
      ),
    );
  }
}

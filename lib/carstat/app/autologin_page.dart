import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutologinPage extends StatefulWidget {
  const AutologinPage({super.key});

  @override
  State<AutologinPage> createState() => _AutologinPageState();
}

class _AutologinPageState extends State<AutologinPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  void _showConnectivityDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('You are logged in but not connected to the internet.'),
                Text('Some features may not be available.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToNextPage() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString('currentUser') != null;
    final connectivityResult = await Connectivity().checkConnectivity();

    if (isLoggedIn) {
      if (connectivityResult == ConnectivityResult.none) {
        _showConnectivityDialog();
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

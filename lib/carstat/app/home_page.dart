import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flash_light_control_plugin/flash_light_control_plugin.dart';
import 'package:flutter/material.dart';
import 'package:my_project/carstat/app/add_car_form.dart';
import 'package:my_project/carstat/home/bottom_part.dart';
import 'package:my_project/carstat/home/drawer.dart';
import 'package:my_project/carstat/logic/models/car.dart';
import 'package:my_project/carstat/logic/services/car/car_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ICarService _carService;
  late Future<List<Car>> _carListFuture;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _carService = CarService();
    _carListFuture = _carService.loadCarList();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoInternetDialog();
      }
    });
    if (Platform.isIOS) {
      _showIOSNotification();
    }
  }

  void _showIOSNotification() {
    if (Platform.isIOS) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Notice'),
            content: const Text('YOU IOS, NO FLASHLIGHT'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showNoInternetDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('You have lost connection to the internet.'
              ' Some features may not be available.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Car Stats Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Car>>(
              future: _carListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final cars = snapshot.data!;
                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return ListTile(
                        title: Text('${car.make} ${car.model}'),
                        subtitle: Text(
                            'Year: ${car.year} - Mileage: ${car.mileage} - '
                                '0 to 60: ${car.zero_to_sixty}s',),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _carService.deleteCar(car.id);
                                refreshCars();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No cars added yet.'));
                }
              },
            ),
          ),
          // Adding the Row with ElevatedButtons here
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: FlashLightControlPlugin.turnOn,
                child: Text('Flashlight On'),
              ),
              ElevatedButton(
                onPressed: FlashLightControlPlugin.turnOff,
                child: Text('Flashlight Off'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onAddPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const AddCarFormPage()),
          );
          refreshCars();
        },
      ),
    );
  }

  void refreshCars() {
    setState(() {
      _carListFuture = _carService.loadCarList();
    });
  }
}

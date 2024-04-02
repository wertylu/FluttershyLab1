import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/carstat/app/add_car_form.dart';
import 'package:my_project/carstat/bloc/home/car_bloc.dart';
import 'package:my_project/carstat/bloc/home/car_events.dart';
import 'package:my_project/carstat/bloc/home/car_states.dart';
import 'package:my_project/carstat/home/bottom_part.dart';
import 'package:my_project/carstat/home/drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late CarBloc _carBloc;

  @override
  void initState() {
    super.initState();
    _carBloc = context.read<CarBloc>();
    _carBloc.add(LoadCar());
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoInternetDialog();
      }
    });
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
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is CarLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CarLoaded) {
            final cars = state.carList;
            if (cars.isEmpty) {
              return const Center(child: Text('No cars added yet.'));
            }
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  title: Text('${car.make} ${car.model}'),
                  subtitle: Text('Year: ${car.year} - Mileage: ${car.mileage} '
                      '- 0 to 60: ${car.zero_to_sixty}s'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<CarBloc>().add(DeleteCar(car.id));
                    },
                  ),
                );
              },
            );
          } else if (state is CarLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onAddPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const AddCarFormPage()),
          );
          context.read<CarBloc>().add(LoadCar());
        },
      ),
    );
  }
}

import 'package:my_project/carstat/logic/models/car.dart';

abstract class CarState {}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<Car> carList;

  CarLoaded(this.carList);
}

class CarLoadFailure extends CarState {
  final String error;
  CarLoadFailure(this.error);
}

class CarError extends CarState {
  final String message;

  CarError(this.message);
}
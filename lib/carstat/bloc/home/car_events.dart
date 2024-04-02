import 'package:my_project/carstat/logic/models/car.dart';

abstract class CarEvent {}

class LoadCar extends CarEvent {}

class AddCar extends CarEvent {
  final Car car;

  AddCar(this.car);

  List<Object> get props => [car];

}

class DeleteCar extends CarEvent {
  final int id;

  DeleteCar(this.id);
}

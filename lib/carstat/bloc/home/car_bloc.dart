
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/carstat/bloc/home/car_events.dart';
import 'package:my_project/carstat/bloc/home/car_states.dart';
import 'package:my_project/carstat/logic/services/car/car_service.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final CarService _carService;


  CarBloc(this._carService) : super(CarInitial()) {
    on<LoadCar>((event, emit) async {
      emit(CarLoading());
      try {
        final data = await _carService.loadCarList();
        emit(CarLoaded(data));
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });

    on<AddCar>((event, emit) async {
      try {
        await _carService.addCar(event.car);
        add(LoadCar());
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });

    on<DeleteCar>((event, emit) async {
      try {
        await _carService.deleteCar(event.id);
        add(LoadCar());
      } catch (e) {
        emit(CarError(e.toString()));
      }
    });
  }
}
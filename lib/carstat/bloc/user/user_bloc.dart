import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/carstat/bloc/user/user_events.dart';
import 'package:my_project/carstat/bloc/user/user_states.dart';
import 'package:my_project/carstat/logic/models/user.dart';
import 'package:my_project/carstat/logic/services/authentication/authenication_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthService _authService;

  UserBloc(this._authService) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final User? user = await _authService.getUser();
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(UserError('User not found'));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await _authService.register(
          event.name, event.email, event.password,
        );
        if (result == null) {
          emit(UserRegistrationSuccess());
        } else {
          emit(UserRegistrationFailure(result));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(LoginInProgress());
      try {
        final success = await _authService.login(event.email, event.password);
        if (success) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure('Invalid email or password'));
        }
      } catch (e) {
        emit(LoginFailure('Login failed: ${e.toString()}'));
      }
    });

    on<Logout>((event, emit) async {
      await _authService.logout();
      emit(UserInitial());
    });

  }
}
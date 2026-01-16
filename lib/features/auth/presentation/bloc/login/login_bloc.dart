import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc({required this.repository}) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());

    final result = await repository.login(event.email, event.password);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(const LoginNoInternet());
        } else {
          emit(LoginFailed(failure.message));
        }
      },
      (user) {
        emit(LoginSuccess(user));
      },
    );
  }
}

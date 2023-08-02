import 'package:bloc/bloc.dart';
import 'package:http_actions/http_actions.dart';
import 'package:http_actions_example/screens/login/models/login_request.dart';
import 'package:http_actions_example/screens/login/models/login_response.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final HttpActions httpActions;
  LoginBloc({required this.httpActions}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<UserLoginEvent>(_login);
  }

  _login(UserLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginBusyState());

    final response = await httpActions.post(
      "login",
      data: event.request.toJson(),
    );
    if (response.statusCode == 200) {
      LoginResponse loginResponse =
          LoginResponse.fromJson(response.data as Map<String, dynamic>);
      emit(
        LoginBusySuccess(
          response: loginResponse,
        ),
      );
    } else {
      emit(LoginBusyFailure(error: response.data.toString()));
    }
  }
}

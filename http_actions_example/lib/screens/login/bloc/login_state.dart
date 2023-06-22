part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginBusyState extends LoginState {}

class LoginBusySuccess extends LoginState {
  final LoginResponse response;

  LoginBusySuccess({required this.response});
}

class LoginBusyFailure extends LoginState {
  final String error;

  LoginBusyFailure({required this.error});
}

part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class UserLoginEvent extends LoginEvent {
  final LoginRequest request;

  UserLoginEvent(this.request);
}

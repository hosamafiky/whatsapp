abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthConfirmPhoneNumberState extends AuthState {
  final String number;

  AuthConfirmPhoneNumberState(this.number);
}

class AuthSubmittedState extends AuthState {}

class AuthVerifiedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}

class TimerEverySecondState extends AuthState {}

class TimerNintySecondsFinishedState extends AuthState {
  final bool value;

  TimerNintySecondsFinishedState(this.value);
}

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  late String verificationId;

  void confirmPhoneNumber(String number) {
    emit(AuthLoadingState());
    Timer(const Duration(seconds: 3), () {
      emit(AuthConfirmPhoneNumberState(number));
    });
  }

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(AuthLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      timeout: const Duration(seconds: 90),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) {
    log(credential.smsCode!);
    signIn(credential);
  }

  void verificationFailed(FirebaseAuthException exception) {
    log(exception.message!);
    emit(AuthErrorState(exception.message!));
  }

  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    log('Code sent : ${this.verificationId}');
    emit(AuthSubmittedState());
  }

  // Submit OTP..
  void submitOTP(String smsCode) {
    emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    signIn(credential);
  }

  void signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(AuthVerifiedState());
    } catch (error) {
      emit(AuthErrorState(error.toString()));
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getUserData() {
    return FirebaseAuth.instance.currentUser!;
  }

  Duration duration = const Duration(seconds: 90);
  Timer? timer;

  void subtractTime() {
    const subtractSeconds = 1;
    final seconds = duration.inSeconds - subtractSeconds;
    duration = Duration(seconds: seconds);
    emit(TimerEverySecondState());
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => subtractTime());
    Timer(const Duration(seconds: 90), () {
      timer!.cancel();
      emit(TimerNintySecondsFinishedState(true));
    });
  }
}

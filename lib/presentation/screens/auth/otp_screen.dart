import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/auth_cubit/auth_cubit.dart';
import 'package:whatsapp_clone/business_logic/auth_cubit/auth_state.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import '../../../constants/palette.dart';
import 'login_screen.dart';
import '../user_information/user_information_screen.dart';
import '../../widgets/auth_widgets/custom_form_field.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = '/otp-screen';
  final String phoneNumber;
  const OtpScreen(this.phoneNumber, {Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isServiceEnabled = false;

  @override
  void initState() {
    super.initState();
    AuthCubit.get(context).startTimer();
  }

  Widget buildTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final seconds =
        twoDigits(AuthCubit.get(context).duration.inSeconds.remainder(60));
    final minutes =
        twoDigits(AuthCubit.get(context).duration.inMinutes.remainder(60));

    return Text('$minutes:$seconds');
  }

  late Map<String, String> selectedCountry;

  final smsCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is TimerNintySecondsFinishedState) {
          isServiceEnabled = state.value;
        } else if (state is AuthVerifiedState) {
          Navigator.restorablePushNamedAndRemoveUntil(
            context,
            UserInformationScreen.routeName,
            (route) => false,
            arguments: true,
          );
        } else if (state is AuthErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.error);
        } else if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthSubmittedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Palette.backgroundColor,
            title: const Text(
              'Verify your number',
              style: TextStyle(
                color: Palette.tabColor,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  log(value);
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Help',
                    child: Text(
                      'Help',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              const Text(
                'Waiting to automatically detect an sms sent to ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+${widget.phoneNumber}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.routeName,
                      (route) => false,
                    ),
                    child: const Text(
                      'Wrong number?',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120.0),
                child: CustomFormField(
                  hintText: '- - -  - - -',
                  controller: smsCodeController,
                  hintTextColor: Colors.black,
                  hintTextWeight: FontWeight.bold,
                  fontSize: 18.0,
                  onFieldSubmitted: (value) {
                    cubit.submitOTP(value!);
                  },
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Enter 6-digit code',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 15.0),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chat,
                    color: !isServiceEnabled ? Colors.grey : Palette.tabColor,
                  ),
                ),
                title: !isServiceEnabled
                    ? const Text(
                        'Resend SMS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : InkWell(
                        onTap: () =>
                            cubit.submitPhoneNumber(widget.phoneNumber),
                        child: const Text(
                          'Resend SMS',
                          style: TextStyle(
                            color: Palette.tabColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                trailing:
                    !isServiceEnabled ? buildTimer() : const SizedBox.shrink(),
              ),
              Divider(
                height: 2.0,
                thickness: 1.0,
                color: Colors.grey[300],
                endIndent: 20.0,
                indent: 20.0,
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.call,
                    color: !isServiceEnabled ? Colors.grey : Palette.tabColor,
                  ),
                ),
                title: !isServiceEnabled
                    ? const Text(
                        'Call me',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : InkWell(
                        onTap: () {},
                        child: const Text(
                          'Call me',
                          style: TextStyle(
                            color: Palette.tabColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                trailing:
                    !isServiceEnabled ? buildTimer() : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

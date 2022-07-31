import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/auth_cubit/auth_cubit.dart';
import 'package:whatsapp_clone/business_logic/auth_cubit/auth_state.dart';
import '../../../constants/palette.dart';
import 'otp_screen.dart';
import 'select_dial_code.dart';
import '../../widgets/auth_widgets/confirm_number_dialog.dart';
import '../../widgets/auth_widgets/loading_dialog.dart';
import '../../widgets/auth_widgets/custom_button.dart';
import '../../widgets/auth_widgets/custom_form_field.dart';
import '../../widgets/auth_widgets/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final Map<String, String>? country;
  const LoginScreen({Key? key, this.country}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Map<String, String> selectedCountry;
  String phoneNumber = '';
  final dialCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String getPhoneNumber() {
    if (selectedCountry['name']!.toLowerCase() == 'egypt') {
      if (phoneNumberController.text.length == 11) {
        return phoneNumberController.text.substring(1);
      } else {
        return phoneNumberController.text;
      }
    } else {
      return phoneNumberController.text;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.country != null
        ? widget.country!
        : {
            'name': 'Egypt',
            'code': 'EG',
            'dialCode': '+20',
          };
    dialCodeController.text = selectedCountry['dialCode']!.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        var cubit = AuthCubit.get(context);
        if (state is AuthLoadingState) {
          showDialog(
            context: context,
            builder: (context) {
              return const LoadingDialog();
            },
          );
        } else if (state is AuthConfirmPhoneNumberState) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              phoneNumber = state.number;
              return ConfirmNumberDialog(
                state.number,
                onEditPressed: () => Navigator.pop(context),
                onOkeyPressed: () {
                  Navigator.pop(context);
                  cubit.submitPhoneNumber(state.number);
                },
              );
            },
          );
        } else if (state is AuthSubmittedState) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber)),
            (route) => false,
          );
        } else if (state is AuthErrorState) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error,
                    size: 40.0,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
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
              'Enter your phone number',
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
                'WhatsApp will need to verify your phone number.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: CustomFormField(
                  textAlign: TextAlign.center,
                  hintText: dialCodeController.text.isEmpty
                      ? 'Choose a country'
                      : selectedCountry['name'],
                  hintTextColor: Colors.black,
                  hintTextWeight: FontWeight.w400,
                  suffixIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Palette.tabColor,
                    size: 30.0,
                  ),
                  readOnly: true,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTap: () => Navigator.pushNamed(
                    context,
                    DialCodeScreen.routeName,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: CustomFormField(
                          controller: dialCodeController,
                          prefixIcon: const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      flex: 3,
                      child: CustomFormField(
                        textAlign: TextAlign.start,
                        controller: phoneNumberController,
                        hintText: 'phone number',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Carrier charges may apply.',
                style: TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              CustomButton(
                text: 'Next',
                textSize: 16.0,
                width: 80.0,
                onTap: () {
                  if (phoneNumberController.text.length < 10) {
                    showDialog(
                      context: context,
                      builder: (context) => const ErrorDialog(
                        error: 'You\'ve to enter a valid phone number.',
                      ),
                    );
                  } else {
                    cubit.confirmPhoneNumber(
                        '${dialCodeController.text}${getPhoneNumber()}');
                  }
                },
              ),
              const SizedBox(height: 70.0),
            ],
          ),
        );
      },
    );
  }
}

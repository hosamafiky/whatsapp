import 'package:flutter/material.dart';

import '../../../constants/palette.dart';
import '../../widgets/auth_widgets/custom_button.dart';
import '../auth/login_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = '/landing';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 45.0),
            const Text(
              'Welcome to WhatsApp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 33.0,
                fontWeight: FontWeight.w600,
                color: Palette.tabColor,
              ),
            ),
            SizedBox(height: size.height / 12),
            Image.asset(
              'assets/images/bg.png',
              width: 300.0,
              height: 300.0,
              color: Palette.tabColor,
            ),
            SizedBox(height: size.height / 12),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Read our ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: TextStyle(
                        color: Palette.tabColor,
                      ),
                    ),
                    TextSpan(
                      text: ' Tap "Agree and continue" to accept the',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: ' Terms of Service',
                      style: TextStyle(
                        color: Palette.tabColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: 0.75 * size.width,
              child: CustomButton(
                text: 'AGREE AND CONTINUE',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (route) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

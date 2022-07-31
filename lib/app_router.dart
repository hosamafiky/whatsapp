import 'package:flutter/material.dart';

import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/otp_screen.dart';
import 'presentation/screens/auth/select_dial_code.dart';
import 'presentation/screens/camera/camera_screen.dart';
import 'presentation/screens/camera/camera_view_screen.dart';
import 'presentation/screens/camera/video_view_screen.dart';
import 'presentation/screens/landing/landing_screen.dart';
import 'presentation/screens/layouts/mobile_screen_layout.dart';
import 'presentation/screens/new_group_screen.dart';
import 'presentation/screens/select_contact_screen.dart';
import 'presentation/screens/single_chat_screen.dart';
import 'presentation/screens/user_information/user_information_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MobileScreenLayout.routeName:
        return MaterialPageRoute(
          builder: (context) => const MobileScreenLayout(),
        );
      case SingleChatScreen.routeName:
        final userModel = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => SingleChatScreen(userModel),
        );
      case SelectContactScreen.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => SelectContactScreen(arguments),
        );
      case NewGroupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const NewGroupScreen(),
        );
      case CameraScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        );
      case CameraViewScreen.routeName:
        final path = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => CameraViewScreen(path),
        );
      case VideoViewScreen.routeName:
        final path = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => VideoViewScreen(path),
        );
      case LoginScreen.routeName:
        final country = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (context) => LoginScreen(country: country),
        );
      case OtpScreen.routeName:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OtpScreen(phoneNumber),
        );
      case DialCodeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const DialCodeScreen(),
        );
      case LandingScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const LandingScreen(),
        );
      case UserInformationScreen.routeName:
        final value = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (context) => UserInformationScreen(isFirst: value),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No module is specified for this route.'),
            ),
          ),
        );
    }
  }
}

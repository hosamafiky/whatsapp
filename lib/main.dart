import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/auth_cubit/auth_cubit.dart';
import 'business_logic/chats_cubit/chats_cubit.dart';
import 'business_logic/info_cubit/info_cubit.dart';
import 'business_logic/bloc_observer.dart';
import 'presentation/screens/landing/landing_screen.dart';
import 'presentation/screens/layouts/mobile_screen_layout.dart';

import 'app_router.dart';
import 'constants/palette.dart';
import 'firebase_options.dart';
import 'presentation/screens/camera/camera_screen.dart';

late String initialRoute;
void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          initialRoute = LandingScreen.routeName;
        } else {
          initialRoute = MobileScreenLayout.routeName;
        }
      });
      cameras = await availableCameras();
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => InfoCubit()),
        BlocProvider(
          create: (context) => ChatsCubit()
            ..getUsers()
            ..getChats(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WhatsApp Clone',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Palette.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Palette.appBarColor,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: initialRoute,
      ),
    );
  }
}

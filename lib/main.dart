import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'core/Services/App/app.service.dart';
import 'core/Services/Auth/auth.service.dart';
import 'core/Services/Auth/src/Providers/auth_provider.dart';
import 'core/Services/FCM Notification/fcm.notification.service.dart';
import 'core/Services/Firebase/firebase.service.dart';
import 'core/Services/Notification/notification.service.dart';
import 'features/authentication/presentation/pages/landing.screen.dart';
import 'features/skeleton/skeleton_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await App.initialize(AppEnvironment.dev);
  await FirebaseService.initialize();
  //
  await NotificationService.initialize();
  //
  //
  await FCMNotification().initNotifications();
  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData customDarkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F1114),
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Color(0xFF1A1E23),
        surface: Color(0xFF2C2F3A),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white60),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.white70),
      ),
      cardColor: Colors.white.withOpacity(0.05),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customDarkTheme,

      home: StreamBuilder(
        stream: AuthService(
          authProvider: FirebaseAuthProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
        ).isUserLoggedIn(),
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            return const SkeletonScreen();
          } else {
            return const LandingScreen();
          }
        },
      ),
    );
  }
}

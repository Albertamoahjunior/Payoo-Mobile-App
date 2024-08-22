import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'utils/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const PayooApp());
}

class PayooApp extends StatelessWidget {
  const PayooApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payoo',
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
          ),
        ),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/custom_button.dart';
import '../utils/colors.dart';
import './home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //google authentication
  Future<User?> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Height on top of the image
              const SizedBox(height: 30),
              Image.asset(
                'assets/shoot.png', // Replace with your image path
                height: MediaQuery.of(context).size.height *
                    0.2, // Adjust the height to your preference
                width: MediaQuery.of(context).size.width *
                    0.6, // Adjust the width to your
              ),
              //const SizedBox(height: 5), // Add some space between the image and the text
              const Text(
                'Payoo',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Instant payment  •  No Wahala',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 80),
              const Text(
                'Login/Register to Continue',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Continue with Google',
                onPressed: () async {
                  User? user = await _signInWithGoogle();

                    if (user != null) {
                      // Prepare the request body
                      final requestBody = {
                        "id": user.uid,
                        "userEmail": user.email,
                        "phoneNumber": user.phoneNumber ?? '',
                        "userName": user.displayName ?? ''
                      };

                      // Make the API request (using any HTTP client like http package in Flutter)
                      final response = await http.post(
                        Uri.parse('http://100.66.114.55:8000/users/'),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(requestBody),
                      );

                      if ((response.statusCode == 201) || (response.statusCode == 200)) {
                        print('User created successfully');
                      } else {
                        print('Failed to create user');
                      }
                    }

                },
                icon: 'assets/google.png',
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Continue with Apple',
                onPressed: () {},
                icon: Icons.apple,
              ),
              const SizedBox(height: 20),
              const Text(
                'By proceeding, you agree to our Terms and Conditions and our Privacy Policy.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

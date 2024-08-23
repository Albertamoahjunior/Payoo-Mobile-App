import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/custom_button.dart';
import './home_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String amount;
  final String shopName;

  const PaymentSuccessScreen({
    Key? key,
    required this.amount,
    required this.shopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.4; // Adjust the size based on screen width

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedBottomClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              color: AppColors.primary, // Your primary color
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/checkmark.png', // Replace with your image asset path
                      height: imageSize,
                      width: imageSize,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Payment of',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'GH\u20B5 $amount',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        color: AppColors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'to',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      shopName.toUpperCase(),
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                   SizedBox(height: 20),
                    Text(
                      'Successful!',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          CustomButton(
            text: 'BACK HOME',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary, // Your primary color
            foregroundColor: AppColors.white,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.9);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height * 0.9);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

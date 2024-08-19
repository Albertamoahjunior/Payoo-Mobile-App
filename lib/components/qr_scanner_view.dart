import 'package:flutter/material.dart';
import '../utils/colors.dart';

class QRScannerView extends StatelessWidget {
  final double height;

  const QRScannerView({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tap to Scan', // Add your desired text here
            style: TextStyle(
              color: AppColors.white,
              fontSize: height * 0.06, // Adjust text size based on container height
            ),
          ),
          SizedBox(height: height * 0.05), // Adjust the space between the text and icon
          Icon(
            Icons.qr_code_scanner,
            size: height * 0.5, // Adjust icon size based on container height
            color: AppColors.white,
          ),
        ],
      ),
    ),
  );
 }
}
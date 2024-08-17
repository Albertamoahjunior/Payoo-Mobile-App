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
        child: Icon(
          Icons.qr_code_scanner,
          size: height * 0.3, // Adjust icon size based on container height
          color: AppColors.white,
        ),
      ),
    );
  }
}
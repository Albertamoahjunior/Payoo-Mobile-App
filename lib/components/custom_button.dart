import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final dynamic icon; // Can be either IconData or String
  final Color backgroundColor; // Add this parameter
  final Color foregroundColor; // Add this parameter

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.white, // Default to white if not provided
    this.foregroundColor = AppColors.black, // Default to black if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.07,
      width: screenWidth * 0.9,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? _buildIcon() : const SizedBox.shrink(), // Show icon if provided
        label: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor, // Use the passed background color
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon, color: AppColors.black);
    } else if (icon is String) {
      return Image.asset(
        icon,
        height: 24, // Set desired icon size
        width: 24,
        //color: AppColors.black, // Optional: color overlay for the image
      );
    } else {
      throw ArgumentError('icon must be either an IconData or a String representing the asset path');
    }
  }
}

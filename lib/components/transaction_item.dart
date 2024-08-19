import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String initials;

  const TransactionItem({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.initials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.wine,
          child: Text(
            initials,
            style: TextStyle(color: AppColors.white),
          ),
        ),
        title: Text(name),
        subtitle: Text(phoneNumber),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
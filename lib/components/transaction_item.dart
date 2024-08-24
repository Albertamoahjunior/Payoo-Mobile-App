import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../screens/transaction_details_screen.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String initials;
  final String amount;
  final String ref;
  final String vendor;

  const TransactionItem({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.initials,
    required this.amount,
    required this.ref,
    required this.vendor,
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                name: name,
                phoneNumber: phoneNumber,
                amount: amount,
                ref: ref,
                vendor: vendor,
              ),
            ),
          );
        },
      ),
    );
  }
}

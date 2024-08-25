import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/custom_button.dart';
import '../components/category_chip.dart';
import 'payment_success_screen.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String amount;
  final String ref;
  final String vendor;

  const TransactionDetailsScreen({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.amount,
    required this.ref,
    required this.vendor,
  }) : super(key: key);

  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late TextEditingController _refController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _refController = TextEditingController(text: widget.ref);
    _amountController = TextEditingController(text: widget.amount);
  }

  @override
  void dispose() {
    _refController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _setReferenceText(String category) {
    setState(() {
      _refController.text = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vendor',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.normal,
                            fontSize: 20)),
                    Text(widget.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(widget.phoneNumber,
                        style: TextStyle(color: Colors.white)),
                    Text(widget.vendor,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _refController,
              decoration: InputDecoration(
                labelText: 'Reference',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'FOOD',
                'DRINKS',
                'SCHOOL',
                'SANITARY',
                'CLOTHS',
                'OUTING',
                'TRANSPORT',
                'FOOD',
                'OTHER'
              ]
                  .map((category) => CustomCategoryChip(
                        category: category,
                        width: screenWidth *
                            0.29,
                        height: screenHeight *
                            0.05,
                        onSelected: _setReferenceText,
                      ))
                  .toList(),
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    'Total: GH₵ ${_amountController.text.isNotEmpty ? _amountController.text : '0.00'}',
                    style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                SizedBox(height: 8),
                Text('This includes all taxes + transaction fees',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center),
              ],
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'CONFIRM PAYMENT',
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(
                        amount: _amountController.text,
                        shopName: widget.name,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter an amount')),
                  );
                }
              },
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}


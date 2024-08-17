import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/custom_button.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final String vendorData;

  const PaymentDetailsScreen({Key? key, required this.vendorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Parse vendorData to extract necessary information
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Payment Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                    Text('VENDOR', style: TextStyle(color: Colors.white70)),
                    Text('AMAZING GRACE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('054 876 4990', style: TextStyle(color: Colors.white)),
                    Text('Mrs. Anita See', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Amount e.g. 20',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Reference',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'FOOD', 'DRINKS', 'SCHOOL', 'SANITARY', 'CLOTHS', 'OUTING', 'TRANSPORT', 'FOOD', 'OTHER'
              ].map((category) => Chip(
                label: Text(category),
                backgroundColor: Colors.primaries[category.hashCode % Colors.primaries.length],
              )).toList(),
            ),
            SizedBox(height: 24),
            Text('Total: GH₵32.47', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('This includes all taxes + transaction fees', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),
            CustomButton(
              text: 'PAY NOW',
              onPressed: () {
                // TODO: Implement payment logic
              },
              icon: Icons.payment,
            ),
          ],
        ),
      ),
    );
  }
}
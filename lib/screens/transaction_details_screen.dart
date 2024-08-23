import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/colors.dart';
import '../components/custom_button.dart';
import 'payment_success_screen.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final String vendorData;

  const PaymentDetailsScreen({Key? key, required this.vendorData}) : super(key: key);

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  Map<String, dynamic>? vendorDetails;
  bool isLoading = true;
  final TextEditingController _amountController = TextEditingController(); // Controller for the amount text field

  @override
  void initState() {
    super.initState();
    fetchVendorDetails(widget.vendorData);
  }

  Future<void> fetchVendorDetails(String vendorId) async {
    final response = await http.get(Uri.parse('https://payoo-backend.vercel.app/vendors/$vendorId'));

    if (response.statusCode == 200) {
      setState(() {
        vendorDetails = json.decode(response.body);
        isLoading = false;

        if (vendorDetails?['accountStatus'] == 'inactive') {
          showVendorInactiveDialog();
        }
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  void showVendorInactiveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vendor Inactive',
            style: TextStyle(color: AppColors.white),
          ),
          content: Text('This vendor is no more active in our system and cannot be used for payments.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.background,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('OK', 
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : vendorDetails == null 
          ? Center(child: Text('Error loading vendor details'))
          : SingleChildScrollView(
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
                          Text('VENDOR', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal)),
                          Text(vendorDetails!['shopName'], style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(vendorDetails!['phoneNumber'], style: TextStyle(color: Colors.white)),
                          Text(vendorDetails!['vendorName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _amountController, // Attach the controller
                    decoration: InputDecoration(
                      hintText: 'Amount e.g. 20',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Update UI when the amount changes
                    },
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
                    ].map((category) => SizedBox(
                      width: 100, // Adjust this width to your desired size
                      child: Chip(
                        label: Text(
                          category,
                          style: TextStyle(color: Colors.black), // Black text color
                        ),
                        backgroundColor: Colors.primaries[category.hashCode % Colors.primaries.length],
                      ),
                    )).toList(),
                  ),
                  SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text( 'Total: GH₵ ${_amountController.text.isNotEmpty ? _amountController.text : '0.00'}', style: TextStyle(fontFamily: 'NotoSans', fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      SizedBox(height: 8),
                      Text('This includes all taxes + transaction fees', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal), textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(height: 24),
                  CustomButton(
                    text: 'REDO TRANSACTION',
                     onPressed: () {
                        if (_amountController.text.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentSuccessScreen(
                                amount: _amountController.text,
                                shopName: vendorDetails!['shopName'],
                              ),
                            ),
                          );
                        } else {
                          // Show an error message if amount is empty
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

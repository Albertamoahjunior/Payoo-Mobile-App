import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../components/qr_scanner_view.dart';
import '../components/transaction_item.dart';
import '../utils/colors.dart';
import 'profile_screen.dart';
import 'payment_details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanning = false;
  bool isLoadingTransactions = true;  // Add this flag to indicate loading
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  List<dynamic> transactions = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      _loadTransactions();
      _fetchTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('transactions');
    if (storedData != null) {
      setState(() {
        transactions = json.decode(storedData);
      });
    }
  }

  Future<void> _fetchTransactions() async {
    if (userId == null) return;  // Ensure userId is loaded

    final response = await http.get(Uri.parse(
        'https://payoo-backend.vercel.app/users/$userId/transactions'));
    if (response.statusCode == 200) {
      setState(() {
        transactions = json.decode(response.body);
        isLoadingTransactions = false;
      });
      _saveTransactions();
    } else {
      setState(() {
        isLoadingTransactions = false;
      });
      print("Failed to load transactions");
    }
  }

  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('transactions', json.encode(transactions));
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      setState(() {
        isScanning = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentDetailsScreen(vendorData: scanData.code!),
        ),
      ).then((_) => controller.resumeCamera());
    });
  }

  void _profile() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProfileScreen())
      );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        leading: isScanning
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  setState(() {
                    isScanning = false;
                  });
                },
              )
            : null,
        actions: [
         IconButton(
            icon: Icon(Icons.person, color: AppColors.white),
            iconSize: 40.0, // Set the desired icon size here
            onPressed: () {
              _profile(); // Call the function directly when the icon is pressed
            },
          )
        ],
      ),
      body: isScanning
          ? QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _startScanning,
                    child: QRScannerView(
                        height: MediaQuery.of(context).size.height * 0.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Frequent Transactions',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: isLoadingTransactions
                      ? Center(child: CircularProgressIndicator())
                      : transactions.isEmpty
                          ? Center(
                              child: Text(
                                'No transactions available',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                final initials = transaction['shopName']
                                    .split(' ')
                                    .map((e) => e[0])
                                    .join();
                                return TransactionItem(
                                  name: transaction['shopName'],
                                  phoneNumber: transaction['vendorPhone'],
                                  initials: initials,
                                  amount: transaction['amount'].toString(),
                                  ref: transaction['reference'],
                                  vendor: transaction['vendorName']
                                );
                              },
                            ),
                ),
              ],
            ),
    );
  }
}

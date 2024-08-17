import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../components/qr_scanner_view.dart';
import '../components/transaction_item.dart';
import '../utils/colors.dart';
import 'login_screen.dart';
import 'payment_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanning = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

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
      // Navigate to PaymentDetailsScreen with scanned data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentDetailsScreen(vendorData: scanData.code!),
        ),
      ).then((_) => controller.resumeCamera());
    });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Handle logout error if needed
      print("Logout failed: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scannerHeight = screenSize.height * 0.4; // 40% of screen height

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: AppColors.white),
            onSelected: (String result) {
              if (result == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isScanning
                ? Container(
                    height: scannerHeight,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  )
                : GestureDetector(
                    onTap: _startScanning,
                    child: QRScannerView(height: scannerHeight),
                  ),
          ),
          if (!isScanning) ...[
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
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    name: 'Amazing Grace',
                    phoneNumber: '054 876 4990',
                    initials: 'AG',
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

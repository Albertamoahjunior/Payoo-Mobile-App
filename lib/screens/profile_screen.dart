import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';
import '../components/custom_button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> userProfile = {
    'name': '',
    'email': '',
    'phone': '',
    'accountNumber': '',
  };
  File? _imageFile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userProfile['name'] = prefs.getString('userName') ?? 'Not set';
      userProfile['email'] = prefs.getString('userEmail') ?? 'Not set';
      userProfile['phone'] = prefs.getString('userPhone') ?? '';
      // userProfile['accountNumber'] = prefs.getString('accountNumber') ?? 'Not set';
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        _imageFile = File(imagePath);
      }
      isLoading = false;
    });
  }

  Future<void> _setPhoneNumber() async {
    String? phoneNumber = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? newPhoneNumber;
        return AlertDialog(
          title: Text('Add Phone Number'),
          content: TextField(
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              newPhoneNumber = value;
            },
            decoration: InputDecoration(hintText: "Enter your phone number"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(newPhoneNumber);
              },
            ),
          ],
        );
      },
    );

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phoneNumber);
      setState(() {
        userProfile['phone'] = phoneNumber;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', _imageFile!.path);
    }
  }

  //log users out
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: AppColors.primary,
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Text(
                                userProfile['name']![0],
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ProfileItem(title: 'Name', value: userProfile['name']!),
                  ProfileItem(title: 'Email', value: userProfile['email']!),
                  ProfileItem(
                    title: 'Phone',
                    value: userProfile['phone']!.isNotEmpty
                        ? userProfile['phone']!
                        : 'Not set',
                    trailing: userProfile['phone']!.isEmpty
                        ? TextButton(
                            onPressed: _setPhoneNumber,
                            child: Text('Add Phone Number'),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                          )
                        : null,
                  ),
                  // ProfileItem(title: 'Account Number', value: userProfile['accountNumber']!),
                  SizedBox(height: 24),
                  CustomButton(
                    text: 'Edit Profile',
                    onPressed: () {
                      // TODO: Implement edit profile functionality
                    },
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    text: 'Log Out',
                    onPressed: () {
                      // TODO: Implement logout functionality
                      _logout();
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget? trailing;

  const ProfileItem({
    Key? key,
    required this.title,
    required this.value,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: AppColors.white),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.white),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:blogs/Model/user_model.dart';
import 'package:blogs/network_services/auth_controller.dart';
import 'package:blogs/network_services/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final User_Model user;

  const ProfileUpdateScreen({super.key, required this.user});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? path;
  late String email;
  late String username;

  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final profile = widget.user.profile_model;
    email = widget.user.email;
    username = widget.user.username;

    _bioController = TextEditingController(text: profile.bio ?? '');
    _locationController = TextEditingController(text: profile.location ?? '');
    _phoneController = TextEditingController(text: profile.phone_number ?? '');
    _birthDateController = TextEditingController(text: profile.birth_date ?? '');
    _firstNameController =
        TextEditingController(text: widget.user.firstname);
    _lastNameController =
        TextEditingController(text: widget.user.lastname);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> requestBody = {
          'email': email,
          'username': username,
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'profile': {
            'bio': _bioController.text.trim(),
            'location': _locationController.text.trim(),
            'phone_number': _phoneController.text.trim(),
            'birth_date': _birthDateController.text.trim(),
            if (path != null) "profile_image": path,
          }
        };


        var response = await http.put(
          Uri.parse(Urls.profileUpdate),
          headers: {
            "Authorization": "Bearer ${AuthController.accessToken}",
            "Content-Type": "application/json",
          },
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
          Navigator.pop(context, true);
        } else {
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Update failed: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  Future<void> _imagePicker() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      path = base64Encode(imageBytes);
      setState(() {});
    }
  }


  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _imagePicker,
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name fields
              TextFormField(
                controller: _firstNameController,
                decoration: _inputDecoration("First Name", Icons.person),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: _inputDecoration("Last Name", Icons.person_outline),
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                decoration: _inputDecoration("Bio", Icons.info_outline),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: _inputDecoration("Location", Icons.location_on),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Phone Number", Icons.phone),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _birthDateController,
                decoration: _inputDecoration("Birth Date (YYYY-MM-DD)", Icons.date_range),
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}

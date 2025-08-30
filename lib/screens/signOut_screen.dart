

import 'package:blogs/Model/user_model.dart';
import 'package:blogs/network_services/New/new_network_caller.dart';
import 'package:blogs/network_services/auth_controller.dart';
import 'package:blogs/network_services/headers.dart';
import 'package:blogs/network_services/urls.dart';
import 'package:blogs/screens/change_password_screen.dart';
import 'package:blogs/screens/profile_update_screen.dart';
import 'package:blogs/screens/signInScreen.dart';
import 'package:flutter/material.dart';

class SignoutScreen extends StatefulWidget {
  const SignoutScreen({super.key});

  @override
  State<SignoutScreen> createState() => _SignoutScreenState();
}

class _SignoutScreenState extends State<SignoutScreen> {
  User_Model? userdata;

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    final username = userdata?.username ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: userdata == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image Section
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: ClipOval(
                    child: userdata!.profile_model.profile_image != null
                        ? Image.file(
                      userdata!.profile_model.profile_image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.person, size: 60, color: Colors.grey[400]),
                    )
                        : Icon(Icons.person, size: 60, color: Colors.grey[400]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Username
            Text(
              "@${userdata!.username}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 5),

            // Name
            Text(
              "${userdata!.firstname} ${userdata!.lastname}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  userdata!.email,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Profile Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.info, "Bio", userdata!.profile_model.bio ?? "Not provided"),
                    const Divider(),
                    _buildInfoRow(Icons.location_on, "Location", userdata!.profile_model.location ?? "Not provided"),
                    const Divider(),
                    _buildInfoRow(Icons.phone, "Phone", userdata!.profile_model.phone_number ?? "Not provided"),
                    const Divider(),
                    _buildInfoRow(Icons.cake, "Birth Date", userdata!.profile_model.birth_date ?? "Not provided"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  text: "Update",
                  color: Colors.blue,
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileUpdateScreen(user: userdata!)),
                    );
                    if (result == true) {
                      setState(() {
                        _fetchInfo();
                      });
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.lock,
                  text: "Password",
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.logout,
                  text: "Logout",
                  color: Colors.red,
                  onPressed: _Logout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16,color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _Logout() async {
    final Map<String, String> header = {
      'content-type': 'application/json',
      "Authorization": "Bearer ${AuthController.accessToken ?? ''}",
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              NewNetworkResponse response = await New_Network_Caller.postRequest(
                  uri: Urls.signout,
                  header: header
              );
              AuthController.clearData();

              if (response.isSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Signinscreen()),
                      (predicate) => false,
                );
              }else{
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Signinscreen()),
                      (predicate) => false,
                );
              }
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchInfo() async {
    NewNetworkResponse response = await New_Network_Caller.getRequest(
        uri: Urls.profileInfo,
        header: Headers.headerWithAuth
    );

    if (response.isSuccess && response.body != null) {
      setState(() {
        userdata = User_Model.fromJson(response.body!);
      });
    }
  }
}
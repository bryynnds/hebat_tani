import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/login.dart';

class AdminProfilePage extends StatelessWidget {

  Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // Menampilkan alert berhasil logout setelah logout
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Berhasil logout'),
      duration: Duration(seconds: 2),
    ),
  );
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

Future<void> _confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                logout(context); // Melakukan logout
              },
              child: Text('Ya, Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/admin_profile.png'), // Replace with your asset path
            ),
            SizedBox(height: 20),
            Text(
              'admin@gmail.com',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _confirmLogout(context),
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 201, 201, 201),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

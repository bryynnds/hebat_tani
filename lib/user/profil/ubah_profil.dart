import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UbahProfilPage extends StatefulWidget {
  @override
  _UbahProfilPageState createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['username'] ?? '';
          _emailController.text = user.email ?? '';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Check if the new username is unique
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _nameController.text)
          .get();

      if (usernameQuery.docs.isNotEmpty && usernameQuery.docs.first.id != user.uid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username sudah digunakan, pilih yang lain.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Update email if changed
      if (_emailController.text.isNotEmpty && _emailController.text != user.email) {
        await user.updateEmail(_emailController.text);
      }

      // Update password if provided
      if (_newPasswordController.text.isNotEmpty) {
        await user.updatePassword(_newPasswordController.text);
      }

      // Update Firestore user data
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': _nameController.text,
        'email': _emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context); // Back to profile page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              enabled: false,
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: 'Kata Sandi Lama'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Kata Sandi Baru (opsional)'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

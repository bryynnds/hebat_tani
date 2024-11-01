import 'dart:io';

import 'package:flutter/material.dart';
import 'ubah_profil.dart';
import 'notifikasi.dart';
import 'ketentuan_layanan.dart';
import 'kebijakan_privasi.dart';
import '../../login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
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

class _ProfilState extends State<Profil> {
  String userName = 'Nama Pengguna';
  String userEmail = 'email@example.com';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['username'] ?? 'Nama Pengguna';
          userEmail = user.email ?? 'email@example.com';
          profileImageUrl = userDoc['foto_profil'] ??
              'https://example.com/default_profile.jpg'; // URL default jika belum ada
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload ke Firebase Storage
        String fileName = 'profile_pictures/${user.uid}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(File(image.path));

        // Ambil URL dari gambar yang diunggah
        String downloadUrl = await ref.getDownloadURL();

        // Update Firestore dengan URL baru
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'foto_profil': downloadUrl});

        setState(() {
          profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto profil berhasil diperbarui')),
        );
      }
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Profil',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAndUploadImage, // Fungsi untuk unggah foto profil
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 163, 163, 163), // Background warna ikon
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Ubah Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UbahProfilPage()),
                ).then((_) =>
                    _getUserData()); // Mengambil data terbaru saat kembali
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifikasi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotifikasiPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Ketentuan Layanan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KetentuanLayananPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Kebijakan Privasi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KebijakanPrivasiPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}

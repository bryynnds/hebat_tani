import 'package:flutter/material.dart';
import 'ubah_profil.dart';
import 'notifikasi.dart';
import 'ketentuan_layanan.dart';
import 'kebijakan_privasi.dart';
import 'main.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String userName = 'Nama Pengguna';
  String userEmail = 'email@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Profil',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Foto Profil
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://example.com/profile.jpg'), // Ganti dengan URL foto profil
            ),
            SizedBox(height: 16),

            // Nama dan Email
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
                // Aksi untuk mengubah profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UbahProfilPage()),
                );
              },
            ),
            // Menu Notifikasi
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifikasi'),
              onTap: () {
                // Aksi saat menekan notifikasi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotifikasiPage()),
                );
              },
            ),

            // Menu Pengaturan
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Ketentuan Layanan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KetentuanLayananPage()),
                );
                // Aksi saat menekan ketentuan layanan
              },
            ),

            // Menu Kebijakan Privasi
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Kebijakan Privasi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KebijakanPrivasiPage()),
                );
                // Aksi saat menekan kebijakan privasi
              },
            ),

            // Menu Logout
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Aksi saat menekan logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()), // Arahkan ke halaman utama atau login
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

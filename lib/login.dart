import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'registrasi.dart';
import 'TabBar.dart';
import 'admin/admin_TabBar.dart';
import 'user/kalender_pengingat/jadwal_kegiatan.dart';
import 'user/kalender_pengingat/tambah_jadwal.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hebatani',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/TabBar': (context) => const TabBarPage(),
        '/AdminTabBar': (context) => AdminTabBar(),
        '/jadwal_kegiatan': (context) => JadwalKegiatanPage(),
        '/tambah_jadwal': (context) => TambahJadwalPage(),
        '/login': (context) => LoginScreen()
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
  try {
    // Cari pengguna berdasarkan username di Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: usernameController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Ambil email dari data pengguna yang ditemukan
      String email = querySnapshot.docs.first['email'];

      // Lakukan login dengan email yang ditemukan
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/AdminTabBar');
        } else {
          Navigator.pushReplacementNamed(context, '/TabBar');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengguna tidak ditemukan di Firestore.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username tidak ditemukan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login gagal: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  void _signIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Daftar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 150.0,
              ),
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Silahkan masuk menggunakan akun anda',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.person), // Ikon bisa diubah sesuai kebutuhan
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 51, 125, 53),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Masuk',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 255, 255, 255))),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum memiliki akun?',
                      style: TextStyle(fontFamily: 'Poppins')),
                  TextButton(
                    onPressed: _signIn,
                    child: const Text('Daftar',
                        style: TextStyle(fontFamily: 'Poppins')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

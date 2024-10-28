import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan import ini
import 'registrasi.dart';
import 'TabBar.dart'; // Import TabBarPage
import 'admin_TabBar.dart'; // Import admin_TabBar
import 'firebase_options.dart';
import 'tambah_jadwal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/TabBar': (context) => const TabBarPage(),
        '/AdminTabBar': (context) => AdminTabBar(), // Tambahkan route untuk admin
        '/tambah_jadwal': (context) => TambahJadwalPage(),
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
      // Melakukan login dengan Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      // Ambil UID dari pengguna yang sedang login
      String uid = userCredential.user!.uid;

      // Ambil data pengguna dari Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      // Cek apakah dokumen ada dan ambil peran pengguna
      if (userDoc.exists) {
        String role = userDoc['role']; // Ambil role dari dokumen

        // Navigasi sesuai role
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/AdminTabBar'); // Arahkan ke halaman admin
        } else {
          Navigator.pushReplacementNamed(context, '/TabBar'); // Arahkan ke halaman user biasa
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengguna tidak ditemukan di Firestore.'),
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
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
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
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Fungsi Lupa Password
                  },
                  child: const Text('Lupa Password?',
                      style: TextStyle(fontFamily: 'Poppins')),
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

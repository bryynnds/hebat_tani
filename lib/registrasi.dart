import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'TabBar.dart';

class Daftar extends StatelessWidget {
  const Daftar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          bodySmall: TextStyle(fontFamily: 'Poppins'),
          headlineMedium: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      home: const RegisterScreen(),
      routes: {
        '/TabBar': (context) => const TabBarPage(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isTermsAccepted = false;

  void _register() async {
    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat dan ketentuan!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } else if (passwordController.text == confirmPasswordController.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun berhasil dibuat!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak cocok!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
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
                'Daftar Akun Baru',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Silahkan isi data akun baru anda',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
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
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _isTermsAccepted = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Dengan ini saya menyetujui syarat dan ketentuan yang berlaku',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 51, 125, 53),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Daftar', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: _goToLogin,
                    child: const Text('Masuk'),
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

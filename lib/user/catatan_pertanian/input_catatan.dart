import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InputCatatanPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  InputCatatanPage({super.key});

  Future<void> addNote() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(
          "User ID: ${user.uid}"); // Tambahkan log ini untuk memastikan ID pengguna

      await FirebaseFirestore.instance.collection('catatan').add({
        'judul': titleController.text,
        'deskripsi': descriptionController.text,
        'tanggal': DateTime.now().toString(),
        'userId': user.uid, // Tambahkan userId di sini
      });
    } else {
      print("User belum login");
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
          'Tambah Catatan',
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
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: 'Judul Catatan', border: OutlineInputBorder())),
            const SizedBox(height: 16.0),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Deskripsi Catatan',
                    border: OutlineInputBorder()),
                maxLines: 5),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                addNote().then((_) => Navigator.pop(context));
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}

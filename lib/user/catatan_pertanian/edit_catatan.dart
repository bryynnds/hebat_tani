import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCatatanPage extends StatelessWidget {
  final String noteId;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  EditCatatanPage({super.key, required this.noteId, required String title, required String description, required String date})
      : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description);

  Future<void> updateNote() async {
    await FirebaseFirestore.instance.collection('catatan').doc(noteId).update({
      'judul': titleController.text,
      'deskripsi': descriptionController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Edit Catatan',
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
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Judul Catatan', border: OutlineInputBorder())),
            const SizedBox(height: 16.0),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Deskripsi Catatan', border: OutlineInputBorder()), maxLines: 5),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                updateNote().then((_) => Navigator.pop(context));
              },
              child: const Text("Selesai"),
            ),
          ],
        ),
      ),
    );
  }
}

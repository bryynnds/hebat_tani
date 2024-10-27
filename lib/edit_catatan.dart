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
      appBar: AppBar(title: const Text('Edit Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Judul Catatan')),
            const SizedBox(height: 16.0),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Deskripsi Catatan'), maxLines: 5),
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

import 'package:flutter/material.dart';

class EditCatatanPage extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  EditCatatanPage({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  })  : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Edit Catatan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul Catatan'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Catatan'),
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Logika simpan perubahan catatan
                Navigator.pop(context);
              },
              child: const Text("Selesai"),
            ),
          ],
        ),
      ),
    );
  }
}

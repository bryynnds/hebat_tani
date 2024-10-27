import 'package:flutter/material.dart';

class AdminEditJenisTanamanPage extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final Function(String, String) onSave; // Tambahkan parameter callback

  AdminEditJenisTanamanPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onSave, // Inisialisasi callback
  });

  @override
  _AdminEditJenisTanamanPageState createState() => _AdminEditJenisTanamanPageState();
}

class _AdminEditJenisTanamanPageState extends State<AdminEditJenisTanamanPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveChanges() {
    // Memanggil callback untuk menyimpan perubahan
    widget.onSave(titleController.text, descriptionController.text);
    Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menyimpan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Jenis Tanaman"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Nama Tanaman'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi Tanaman'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

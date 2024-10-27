import 'package:flutter/material.dart';

class EditArtikelPage extends StatefulWidget {
  final String judul;
  final String gambar;
  final String deskripsi;
  final Function(String judul, String gambar, String deskripsi) onSave;

  const EditArtikelPage({
    super.key,
    required this.judul,
    required this.gambar,
    required this.deskripsi,
    required this.onSave,
  });

  @override
  _EditArtikelPageState createState() => _EditArtikelPageState();
}

class _EditArtikelPageState extends State<EditArtikelPage> {
  late TextEditingController judulController;
  late TextEditingController gambarController;
  late TextEditingController deskripsiController;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.judul);
    gambarController = TextEditingController(text: widget.gambar);
    deskripsiController = TextEditingController(text: widget.deskripsi);
  }

  @override
  void dispose() {
    judulController.dispose();
    gambarController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  void saveChanges() {
    widget.onSave(
      judulController.text,
      gambarController.text,
      deskripsiController.text,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Artikel'),
        actions: [
          IconButton(
            onPressed: saveChanges,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(labelText: 'Judul Artikel'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: gambarController,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

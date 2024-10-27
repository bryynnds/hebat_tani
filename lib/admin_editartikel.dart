import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEditArtikel extends StatefulWidget {
  final String articleId;
  final String judul;
  final String deskripsi;
  final String gambar;

  const AdminEditArtikel({
    Key? key,
    required this.articleId,
    required this.judul,
    required this.deskripsi,
    required this.gambar,
  }) : super(key: key);

  @override
  _AdminEditArtikelState createState() => _AdminEditArtikelState();
}

class _AdminEditArtikelState extends State<AdminEditArtikel> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _gambarController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
    _gambarController = TextEditingController(text: widget.gambar);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _gambarController.dispose();
    super.dispose();
  }

  Future<void> _updateArtikel() async {
    final String newJudul = _judulController.text;
    final String newDeskripsi = _deskripsiController.text;
    final String newGambar = _gambarController.text;

    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.articleId)
          .update({
        'judul': newJudul,
        'deskripsi': newDeskripsi,
        'gambar': newGambar,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil diperbarui')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui artikel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _gambarController,
              decoration: const InputDecoration(
                labelText: 'URL Gambar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _updateArtikel,
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

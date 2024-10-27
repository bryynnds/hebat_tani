import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTambahArtikelPage extends StatefulWidget {
  @override
  _AdminTambahArtikelPageState createState() => _AdminTambahArtikelPageState();
}

class _AdminTambahArtikelPageState extends State<AdminTambahArtikelPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  Future<void> addArtikel() async {
    String judul = judulController.text.trim();
    String deskripsi = deskripsiController.text.trim();
    String gambar = gambarController.text.trim();

    // Cek apakah semua input sudah diisi
    if (judul.isEmpty || deskripsi.isEmpty || gambar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    // Buat referensi dokumen baru di koleksi "articles" dan ambil ID-nya
    final docRef = FirebaseFirestore.instance.collection('articles').doc();
    final articleId = docRef.id;

    try {
      // Tambahkan artikel ke Firestore dengan menyimpan articleId di dalam dokumen
      await docRef.set({
        'articleId': articleId, // Menyimpan articleId di dalam data
        'judul': judul,
        'deskripsi': deskripsi,
        'gambar': gambar,
      });

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artikel berhasil ditambahkan')),
      );

      // Reset input setelah artikel ditambahkan
      judulController.clear();
      deskripsiController.clear();
      gambarController.clear();
    } catch (e) {
      // Tampilkan pesan error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan artikel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: gambarController,
              decoration: InputDecoration(
                labelText: 'URL Gambar',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: addArtikel,
                child: Text('Tambah Artikel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    gambarController.dispose();
    super.dispose();
  }
}

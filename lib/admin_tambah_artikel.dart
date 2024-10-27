import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTambahArtikel extends StatefulWidget {
  @override
  _AdminTambahArtikelState createState() => _AdminTambahArtikelState();
}

class _AdminTambahArtikelState extends State<AdminTambahArtikel> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  final CollectionReference _articlesCollection = FirebaseFirestore.instance.collection('articles');

  // Fungsi untuk menambah artikel ke Firestore
  Future<void> _tambahArtikel() async {
    final judul = _judulController.text;
    final deskripsi = _deskripsiController.text;
    final gambar = _gambarController.text;

    if (judul.isNotEmpty && deskripsi.isNotEmpty && gambar.isNotEmpty) {
      await _articlesCollection.add({
        'judul': judul,
        'deskripsi': deskripsi,
        'gambar': gambar,
      });

      // Bersihkan input setelah artikel disimpan
      _judulController.clear();
      _deskripsiController.clear();
      _gambarController.clear();

      // Tampilkan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artikel berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua kolom harus diisi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Artikel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: 'Judul Artikel'),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi Artikel'),
              maxLines: 3,
            ),
            TextField(
              controller: _gambarController,
              decoration: InputDecoration(labelText: 'URL Gambar Artikel'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tambahArtikel,
              child: Text('Simpan Artikel'),
            ),
          ],
        ),
      ),
    );
  }
}

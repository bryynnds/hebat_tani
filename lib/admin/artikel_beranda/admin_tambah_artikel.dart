import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class AdminTambahArtikelPage extends StatefulWidget {
  @override
  _AdminTambahArtikelPageState createState() => _AdminTambahArtikelPageState();
}

class _AdminTambahArtikelPageState extends State<AdminTambahArtikelPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File image, BuildContext context) async {
    try {
      final fileName = basename(image.path);
      final storageRef = FirebaseStorage.instance.ref().child('artikel_images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $e')),
      );
      return null;
    }
  }

  Future<void> addArtikel(BuildContext context) async {
    String judul = judulController.text.trim();
    String deskripsi = deskripsiController.text.trim();

    // Cek apakah semua input sudah diisi
    if (judul.isEmpty || deskripsi.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Unggah gambar dan dapatkan URL-nya
    final imageUrl = await _uploadImage(_selectedImage!, context);

    if (imageUrl != null) {
      // Buat referensi dokumen baru di koleksi "articles" dan ambil ID-nya
      final docRef = FirebaseFirestore.instance.collection('articles').doc();
      final articleId = docRef.id;

      try {
        // Tambahkan artikel ke Firestore dengan menyimpan articleId di dalam dokumen
        await docRef.set({
          'articleId': articleId, // Menyimpan articleId di dalam data
          'judul': judul,
          'deskripsi': deskripsi,
          'gambar': imageUrl,
        });

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil ditambahkan')),
        );
        Navigator.pop(context);

        // Reset input setelah artikel ditambahkan
        judulController.clear();
        deskripsiController.clear();
        setState(() {
          _selectedImage = null;
          _isUploading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan artikel: $e')),
        );
      }
    } else {
      setState(() {
        _isUploading = false;
      });
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
          'Tambah Artikel',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                    )
                  : Image.file(
                      _selectedImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _isUploading ? null : () => addArtikel(context),
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Tambah Artikel'),
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
    super.dispose();
  }
}

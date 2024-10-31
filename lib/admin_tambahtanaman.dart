import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminTambahTanamanPage extends StatefulWidget {
  @override
  _AdminTambahTanamanPageState createState() => _AdminTambahTanamanPageState();
}

class _AdminTambahTanamanPageState extends State<AdminTambahTanamanPage> {
  final TextEditingController _namaTanamanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _imageFile;
  String? _imageUrl; // URL gambar untuk disimpan ke Firebase Firestore

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah gambar ke Firebase Storage
  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;

    try {
      String fileName = 'tanaman_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      // Dapatkan URL gambar setelah berhasil diunggah
      _imageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Fungsi untuk menambah data tanaman ke Firestore
  Future<void> tambahTanaman() async {
    await _uploadImageToFirebase();

    if (_imageUrl != null) {
      await FirebaseFirestore.instance.collection('tanaman').add({
        'nama_tanaman': _namaTanamanController.text,
        'deskripsi': _deskripsiController.text,
        'gambar': _imageUrl, // Simpan URL gambar di Firestore
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data tanaman berhasil ditambahkan')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Tanaman"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaTanamanController,
              decoration: InputDecoration(labelText: "Nama Tanaman"),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: "Deskripsi"),
            ),
            SizedBox(height: 20),
            _imageFile != null
                ? Image.file(_imageFile!, width: 100, height: 100)
                : Text("Belum ada gambar yang dipilih"),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pilih Gambar"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: tambahTanaman,
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminEditTanamanPage extends StatefulWidget {
  final String docId; // ID dokumen Firebase untuk data tanaman

  AdminEditTanamanPage({required this.docId});

  @override
  _AdminEditTanamanPageState createState() => _AdminEditTanamanPageState();
}

class _AdminEditTanamanPageState extends State<AdminEditTanamanPage> {
  final TextEditingController _namaTanamanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _imageFile;
  String? _imageUrl; // URL gambar untuk disimpan di Firestore

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Mendapatkan data tanaman dari Firestore dan mengisi controller
    FirebaseFirestore.instance.collection('tanaman').doc(widget.docId).get().then((snapshot) {
      _namaTanamanController.text = snapshot['nama_tanaman'];
      _deskripsiController.text = snapshot['deskripsi'];
      setState(() {
        _imageUrl = snapshot['gambar']; // Menyimpan URL gambar dari Firestore
      });
    });
  }

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

  // Fungsi untuk memperbarui data tanaman di Firestore
  Future<void> updateTanaman() async {
    // Jika gambar baru dipilih, upload dulu gambar tersebut
    if (_imageFile != null) {
      await _uploadImageToFirebase();
    }

    // Memperbarui data di Firestore, termasuk URL gambar jika diperbarui
    await FirebaseFirestore.instance.collection('tanaman').doc(widget.docId).update({
      'nama_tanaman': _namaTanamanController.text,
      'deskripsi': _deskripsiController.text,
      'gambar': _imageUrl, // URL gambar yang diperbarui atau yang sudah ada
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data tanaman berhasil diperbarui')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Tanaman"),
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
                ? Image.file(_imageFile!, width: 100, height: 100) // Gambar baru yang dipilih
                : _imageUrl != null
                    ? Image.network(_imageUrl!, width: 100, height: 100) // Gambar yang ada di Firebase
                    : Text("Belum ada gambar yang dipilih"),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pilih Gambar"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateTanaman,
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminTambahJenisTanamanPage extends StatefulWidget {
  @override
  _AdminTambahJenisTanamanPageState createState() => _AdminTambahJenisTanamanPageState();
}

class _AdminTambahJenisTanamanPageState extends State<AdminTambahJenisTanamanPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> addTanaman() async {
    if (_imagePath == null) {
      print("Gambar belum dipilih");
      return;
    }

    String fileName = _imagePath!.split('/').last;
    Reference storageRef = FirebaseStorage.instance.ref().child('tanaman_images/$fileName');
    await storageRef.putFile(File(_imagePath!));
    String downloadUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('jenis_tanaman').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imagePath': downloadUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data berhasil ditambahkan')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Jenis Tanaman")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Nama Jenis Tanaman"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Deskripsi"),
            ),
            SizedBox(height: 10),
            _imagePath != null
                ? Image.file(File(_imagePath!), height: 100, width: 100)
                : Text("Tidak ada gambar yang dipilih"),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pilih Gambar"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTanaman,
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}

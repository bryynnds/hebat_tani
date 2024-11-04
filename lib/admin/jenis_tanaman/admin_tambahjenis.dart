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
  File? _imageFile;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> addTanaman() async {
    if (_imageFile == null) {
      print("Gambar belum dipilih");
      return;
    }

    String fileName = 'tanaman_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    await storageRef.putFile(_imageFile!);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Tambah Jenis Tanaman',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: pickImage,
              child: _imageFile == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                    )
                  : Image.file(
                      _imageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: addTanaman,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

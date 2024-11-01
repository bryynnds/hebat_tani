import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminEditJenisTanamanPage extends StatefulWidget {
  final String docId;

  AdminEditJenisTanamanPage({required this.docId});

  @override
  _AdminEditJenisTanamanPageState createState() => _AdminEditJenisTanamanPageState();
}

class _AdminEditJenisTanamanPageState extends State<AdminEditJenisTanamanPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;
  String? _initialImageUrl;

  @override
  void initState() {
    super.initState();
    _loadTanamanData();
  }

  Future<void> _loadTanamanData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('jenis_tanaman').doc(widget.docId).get();
    setState(() {
      _titleController.text = doc['title'];
      _descriptionController.text = doc['description'];
      _initialImageUrl = doc['imagePath'];
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> updateTanaman() async {
  String imageUrl = _initialImageUrl ?? '';
  
  // If a new image is selected, upload it
  if (_imagePath != null) {
    String fileName = _imagePath!.split('/').last;
    Reference storageRef = FirebaseStorage.instance.ref().child('tanaman_images/$fileName');
    await storageRef.putFile(File(_imagePath!));
    imageUrl = await storageRef.getDownloadURL();
  }

  // Update plant type data in Firestore
  await FirebaseFirestore.instance.collection('jenis_tanaman').doc(widget.docId).update({
    'title': _titleController.text,
    'description': _descriptionController.text,
    'imagePath': imageUrl,
  });

  // Show success alert
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Data berhasil diperbarui')),
  );

  // Wait briefly before navigating back
  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Edit Jenis Tanaman',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
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
                : (_initialImageUrl != null
                    ? Image.network(_initialImageUrl!, height: 100, width: 100)
                    : Text("Tidak ada gambar yang dipilih")),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pilih Gambar"),
            ),
            SizedBox(height: 10),
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

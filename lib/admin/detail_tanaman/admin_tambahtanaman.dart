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
  String? _imageUrl;
  String? selectedJenisTanamanId;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;
    try {
      String fileName = 'tanaman_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      _imageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> tambahTanaman() async {
    await _uploadImageToFirebase();
    if (_imageUrl != null && selectedJenisTanamanId != null) {
      await FirebaseFirestore.instance.collection('tanaman').add({
        'nama_tanaman': _namaTanamanController.text,
        'deskripsi': _deskripsiController.text,
        'gambar': _imageUrl,
        'id_jenis_tanaman': selectedJenisTanamanId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data tanaman berhasil ditambahkan')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap lengkapi semua data dan pilih jenis tanaman')),
      );
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
          'Tambah Tanaman',
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
              controller: _namaTanamanController,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('jenis_tanaman').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButtonFormField<String>(
                  hint: Text("Pilih Jenis Tanaman"),
                  value: selectedJenisTanamanId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedJenisTanamanId = newValue;
                    });
                  },
                  items: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return DropdownMenuItem<String>(
                      value: document.id,
                      child: Text(document['title']),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Jenis Tanaman',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
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
                onPressed: tambahTanaman,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

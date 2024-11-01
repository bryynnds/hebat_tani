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
  String? selectedJenisTanamanId; // Menyimpan ID jenis tanaman yang dipilih

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

    if (_imageUrl != null && selectedJenisTanamanId != null) {
      await FirebaseFirestore.instance.collection('tanaman').add({
        'nama_tanaman': _namaTanamanController.text,
        'deskripsi': _deskripsiController.text,
        'gambar': _imageUrl, // Simpan URL gambar di Firestore
        'id_jenis_tanaman': selectedJenisTanamanId, // Simpan ID jenis tanaman
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
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text("Pilih Jenis Tanaman"),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('jenis_tanaman').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<String>(
                  hint: Text("Pilih Jenis Tanaman"),
                  value: selectedJenisTanamanId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedJenisTanamanId = newValue;
                    });
                  },
                  items: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return DropdownMenuItem<String>(
                      value: document.id, // ID dokumen sebagai nilai dropdown
                      child: Text(document['title']), // Nama jenis tanaman ditampilkan
                    );
                  }).toList(),
                );
              },
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

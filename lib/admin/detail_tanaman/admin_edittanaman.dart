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
  bool _isUpdated = false; // Flag untuk melacak jika pembaruan dilakukan

  final TextEditingController _namaTanamanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _imageFile;
  String? _imageUrl; // URL gambar untuk disimpan di Firestore
  String? selectedJenisTanamanId; // Menyimpan ID jenis tanaman yang dipilih

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Mendapatkan data tanaman dari Firestore dan mengisi controller
    FirebaseFirestore.instance
        .collection('tanaman')
        .doc(widget.docId)
        .get()
        .then((snapshot) {
      _namaTanamanController.text = snapshot['nama_tanaman'];
      _deskripsiController.text = snapshot['deskripsi'];
      selectedJenisTanamanId = snapshot['id_jenis_tanaman']; // ID jenis tanaman
      setState(() {
        _imageUrl = snapshot['gambar']; // URL gambar dari Firestore
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
  // Fungsi untuk memperbarui data tanaman di Firestore
// Fungsi untuk memperbarui data tanaman di Firestore
Future<void> updateTanaman() async {
  try {
    // Jika gambar baru dipilih, unggah dulu gambar tersebut
    if (_imageFile != null) {
      await _uploadImageToFirebase();
    }

    // Memperbarui data tanaman di Firestore
    await FirebaseFirestore.instance
        .collection('tanaman')
        .doc(widget.docId)
        .update({
      'nama_tanaman': _namaTanamanController.text,
      'deskripsi': _deskripsiController.text,
      'gambar': _imageUrl,
      'id_jenis_tanaman': selectedJenisTanamanId,
    });

    setState(() {
      _isUpdated = true; // Set flag untuk menunjukkan pembaruan berhasil
    });

    // Tampilkan alert berhasil hanya jika pembaruan berhasil
    if (_isUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data tanaman berhasil diperbarui')),
      );
    }

    // Tunggu sejenak sebelum kembali
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  } catch (e) {
    print("Error updating tanaman: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal memperbarui data tanaman')),
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
          'Edit Tanaman',
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

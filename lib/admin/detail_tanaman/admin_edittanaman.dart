import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminEditTanamanPage extends StatefulWidget {
  final String docId;

  AdminEditTanamanPage({required this.docId});

  @override
  _AdminEditTanamanPageState createState() => _AdminEditTanamanPageState();
}

class _AdminEditTanamanPageState extends State<AdminEditTanamanPage> {
  final TextEditingController _namaTanamanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;
  String? _currentImageUrl;
  String? selectedJenisTanamanId;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('tanaman')
        .doc(widget.docId)
        .get()
        .then((snapshot) {
      _namaTanamanController.text = snapshot['nama_tanaman'];
      _deskripsiController.text = snapshot['deskripsi'];
      selectedJenisTanamanId = snapshot['id_jenis_tanaman'];
      setState(() {
        _currentImageUrl = snapshot['gambar'];
      });
    });
  }

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
      final fileName = 'tanaman_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $e')),
      );
      return null;
    }
  }

  Future<void> _updateTanaman(BuildContext context) async {
    if (_selectedImage != null) {
      setState(() {
        _isUploading = true;
      });
      _currentImageUrl = await _uploadImage(_selectedImage!, context);
      setState(() {
        _isUploading = false;
      });
    }

    try {
      await FirebaseFirestore.instance.collection('tanaman').doc(widget.docId).update({
        'nama_tanaman': _namaTanamanController.text,
        'deskripsi': _deskripsiController.text,
        'gambar': _currentImageUrl,
        'id_jenis_tanaman': selectedJenisTanamanId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tanaman berhasil diperbarui')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data tanaman: $e')),
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
            const SizedBox(height: 16.0),
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('jenis_tanaman').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField<String>(
                  value: selectedJenisTanamanId,
                  hint: const Text("Pilih Jenis Tanaman"),
                  onChanged: (newValue) {
                    setState(() {
                      selectedJenisTanamanId = newValue;
                    });
                  },
                  items: snapshot.data!.docs.map((document) {
                    return DropdownMenuItem<String>(
                      value: document.id,
                      child: Text(document['title']),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage == null
                  ? _currentImageUrl == null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                        )
                      : Image.network(
                          _currentImageUrl!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                  : Image.file(
                      _selectedImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _isUploading ? null : () => _updateTanaman(context),
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

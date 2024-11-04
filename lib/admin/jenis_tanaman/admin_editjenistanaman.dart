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
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('jenis_tanaman')
        .doc(widget.docId)
        .get()
        .then((snapshot) {
      _namaController.text = snapshot['title'];
      _deskripsiController.text = snapshot['description'];
      setState(() {
        _currentImageUrl = snapshot['imagePath'];
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
      final fileName = 'jenis_tanaman_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
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

  Future<void> _updateJenisTanaman(BuildContext context) async {
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
      await FirebaseFirestore.instance.collection('jenis_tanaman').doc(widget.docId).update({
        'title': _namaController.text,
        'description': _deskripsiController.text,
        'imagePath': _currentImageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data jenis tanaman berhasil diperbarui')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data jenis tanaman: $e')),
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
          'Edit Jenis Tanaman',
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
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Jenis Tanaman',
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
                onPressed: _isUploading ? null : () => _updateJenisTanaman(context),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class AdminEditArtikel extends StatefulWidget {
  final String articleId;
  final String judul;
  final String deskripsi;
  final String gambar;

  const AdminEditArtikel({
    Key? key,
    required this.articleId,
    required this.judul,
    required this.deskripsi,
    required this.gambar,
  }) : super(key: key);

  @override
  _AdminEditArtikelState createState() => _AdminEditArtikelState();
}

class _AdminEditArtikelState extends State<AdminEditArtikel> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  File? _selectedImage;
  bool _isUploading = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
    _currentImageUrl = widget.gambar;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
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
      final fileName = basename(image.path);
      final storageRef = FirebaseStorage.instance.ref().child('artikel_images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $e')),
      );
      return null;
    }
  }

  Future<void> _updateArtikel(BuildContext context) async {
    final String newJudul = _judulController.text;
    final String newDeskripsi = _deskripsiController.text;
    String? newImageUrl = _currentImageUrl;

    if (_selectedImage != null) {
      setState(() {
        _isUploading = true;
      });
      newImageUrl = await _uploadImage(_selectedImage!, context);
      setState(() {
        _isUploading = false;
      });
    }

    if (newImageUrl != null) {
      try {
        await FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.articleId)
            .update({
          'judul': newJudul,
          'deskripsi': newDeskripsi,
          'gambar': newImageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil diperbarui')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui artikel: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul',
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
                onPressed: _isUploading ? null : () => _updateArtikel(context),
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

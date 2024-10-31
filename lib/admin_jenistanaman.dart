import 'package:flutter/material.dart';
import 'admin_editjenistanaman.dart'; // Pastikan untuk mengimpor halaman edit

class TanamanInfo {
  String title; // Ubah menjadi String agar bisa diubah
  String description; // Ubah menjadi String agar bisa diubah
  final String imagePath;

  TanamanInfo({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class AdminInformasiTanamanPage extends StatefulWidget {
  @override
  _AdminInformasiTanamanPageState createState() => _AdminInformasiTanamanPageState();
}

class _AdminInformasiTanamanPageState extends State<AdminInformasiTanamanPage> {
  final List<TanamanInfo> tanamanList = [
    TanamanInfo(
      title: 'Tanaman Pangan',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      imagePath: 'assets/images/tanamanpangan.jpg',
    ),
    TanamanInfo(
      title: 'Tanaman Obat',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      imagePath: 'assets/images/tanamanobat.jpg',
    ),
  ];

  void editTanaman(int index) {
    final tanaman = tanamanList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditJenisTanamanPage(
          title: tanaman.title,
          description: tanaman.description,
          imagePath: tanaman.imagePath,
          onSave: (String newTitle, String newDescription) {
            setState(() {
              // Update data tanaman
              tanamanList[index].title = newTitle;
              tanamanList[index].description = newDescription;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Informasi Tanaman")),
      body: ListView.builder(
        itemCount: tanamanList.length,
        itemBuilder: (context, index) {
          final tanaman = tanamanList[index];
          return ListTile(
            leading: Image.asset(tanaman.imagePath, width: 50, height: 50),
            title: Text(tanaman.title),
            subtitle: Text(tanaman.description),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editTanaman(index),
            ),
          );
        },
      ),
    );
  }
}

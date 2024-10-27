import 'package:flutter/material.dart';

class TanamanInfo {
  final String title;
  final String description;
  final String imagePath;

  TanamanInfo({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class AdminDetailTanamanPage extends StatelessWidget {
  final TanamanInfo tanaman;

  AdminDetailTanamanPage({required this.tanaman});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Tanaman")),
      body: Column(
        children: [
          Image.asset(tanaman.imagePath),
          Text(tanaman.title, style: TextStyle(fontSize: 24)),
          Text(tanaman.description),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke halaman edit untuk mengubah detail
            },
            child: Text("Edit Detail Tanaman"),
          ),
        ],
      ),
    );
  }
}

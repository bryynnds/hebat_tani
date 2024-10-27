// admin_edittanaman.dart
import 'package:flutter/material.dart';
import 'data/tanaman_info.dart'; // Impor kelas TanamanInfo

class AdminEditTanamanPage extends StatelessWidget {
  final TanamanInfo tanaman;

  AdminEditTanamanPage({required this.tanaman});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Detail Tanaman")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(tanaman.imagePath),
            Text(tanaman.title, style: TextStyle(fontSize: 24)),
            Text(tanaman.description),
            // Tambahkan form untuk mengedit informasi tanaman di sini
            ElevatedButton(
              onPressed: () {
                // Logika untuk menyimpan perubahan
              },
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifikasi 1'),
            subtitle: Text('Detail notifikasi 1'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifikasi 2'),
            subtitle: Text('Detail notifikasi 2'),
          ),
          // Tambahkan notifikasi lainnya di sini
        ],
      ),
    );
  }
}

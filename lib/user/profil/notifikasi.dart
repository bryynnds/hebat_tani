import 'package:flutter/material.dart';
import 'detailnotifikasi.dart';

class NotifikasiPage extends StatefulWidget {
  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<Map<String, String>> notifikasiList = [
    {
      'title': 'Notifikasi 1',
      'details': 'Detail notifikasi 1',
    },
    {
      'title': 'Notifikasi 2',
      'details': 'Detail notifikasi 2',
    },
    {
      'title': 'Notifikasi 3',
      'details': 'Detail notifikasi 3',
    },
    {
      'title': 'Notifikasi 4',
      'details': 'Detail notifikasi 4',
    },
    {
      'title': 'Notifikasi 5',
      'details': 'Detail notifikasi 5',
    },
    {
      'title': 'Notifikasi 6',
      'details': 'Detail notifikasi 6',
    },
    // Tambahkan notifikasi lainnya di sini
  ];

  void _deleteNotification(int index) {
    setState(() {
      notifikasiList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifikasiList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notifikasiList[index]['title']!),
            subtitle: Text(notifikasiList[index]['details']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNotifikasiPage(
                    title: notifikasiList[index]['title']!,
                    details: notifikasiList[index]['details']!,
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteNotification(index);
              },
            ),
          );
        },
      ),
    );
  }
}

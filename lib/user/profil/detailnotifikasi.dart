import 'package:flutter/material.dart';

class DetailNotifikasiPage extends StatelessWidget {
  final String title;
  final String details;

  DetailNotifikasiPage({required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(details),
      ),
    );
  }
}

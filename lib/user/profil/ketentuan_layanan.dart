import 'package:flutter/material.dart';

class KetentuanLayananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketentuan Layanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Berikut adalah ketentuan layanan yang berlaku...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

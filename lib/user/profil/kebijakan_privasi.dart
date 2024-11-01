import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Berikut adalah kebijakan privasi yang berlaku...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

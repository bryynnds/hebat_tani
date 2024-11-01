import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TanamanPage extends StatelessWidget {
  final String idTanaman;

  const TanamanPage({super.key, required this.idTanaman});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: Text(
          'Detail Tanaman',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('tanaman').doc(idTanaman).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data tanaman tidak ditemukan."));
          }

          final tanamanData = snapshot.data!.data() as Map<String, dynamic>;
          final namaTanaman = tanamanData['nama_tanaman'];
          final deskripsi = tanamanData['deskripsi'];
          final gambar = tanamanData['gambar'];
          final idJenisTanaman = tanamanData['id_jenis_tanaman'];

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('jenis_tanaman').doc(idJenisTanaman).get(),
            builder: (context, jenisSnapshot) {
              if (jenisSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!jenisSnapshot.hasData || !jenisSnapshot.data!.exists) {
                return const Center(child: Text("Jenis tanaman tidak ditemukan."));
              }

              final jenisData = jenisSnapshot.data!.data() as Map<String, dynamic>;
              final jenisTanaman = jenisData['title'];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        gambar,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 100);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      namaTanaman,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Jenis: $jenisTanaman',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),
                    Text(
                      deskripsi,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

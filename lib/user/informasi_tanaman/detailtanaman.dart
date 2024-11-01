import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tanaman.dart';

class DetailTanamanPage extends StatelessWidget {
  final String idJenisTanaman; // ID jenis tanaman yang dipilih
  final String title; // Nama jenis tanaman yang dipilih

  DetailTanamanPage({super.key, required this.idJenisTanaman, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tanaman')
              .where('id_jenis_tanaman', isEqualTo: idJenisTanaman)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Tidak ada tanaman untuk jenis ini."));
            }

            final tanamanDocs = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1,
              ),
              itemCount: tanamanDocs.length,
              itemBuilder: (context, index) {
                var tanamanData = tanamanDocs[index].data() as Map<String, dynamic>;
                final idTanaman = tanamanDocs[index].id;
                final namaTanaman = tanamanData['nama_tanaman'];
                final gambar = tanamanData['gambar'];

                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman detail tanaman
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TanamanPage(idTanaman: idTanaman),
                      ),
                    );
                  },
                  child: buildTanamanCard(namaTanaman, gambar),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Fungsi untuk membangun card tanaman
  Widget buildTanamanCard(String title, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

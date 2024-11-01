import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailtanaman.dart';

class InformasiTanamanPage extends StatefulWidget {
  const InformasiTanamanPage({super.key});

  @override
  State<InformasiTanamanPage> createState() => _InformasiTanamanPageState();
}

class _InformasiTanamanPageState extends State<InformasiTanamanPage> {
  // Mengambil data dari koleksi "jenis_tanaman" di Firebase
  final CollectionReference tanamanCollection = FirebaseFirestore.instance.collection('jenis_tanaman');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: tanamanCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada data jenis tanaman.'));
          }

          // Mendapatkan data dari snapshot Firebase
          final tanamanList = snapshot.data!.docs.map((doc) {
            return {
              'id': doc.id, // Menyimpan ID dokumen
              'title': doc['title'],
              'description': doc['description'],
              'imagePath': doc['imagePath'],
            };
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tanamanList.length,
            itemBuilder: (context, index) {
              return buildCard(tanamanList[index], context);
            },
          );
        },
      ),
    );
  }

  // Fungsi untuk membangun card berdasarkan data
  Widget buildCard(Map<String, dynamic> tanaman, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTanamanPage(
              idJenisTanaman: tanaman['id'], // Mengirim ID jenis tanaman
              title: tanaman['title'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: tanaman['imagePath'] != null && tanaman['imagePath'].isNotEmpty
                  ? Image.network(
                      tanaman['imagePath'],
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tanaman['title'],
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(color: Colors.black),
                  Text(
                    tanaman['description'],
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'detailtanaman.dart';

// Class model untuk menyimpan informasi tanaman
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

class InformasiTanamanPage extends StatefulWidget {
  const InformasiTanamanPage({super.key});

  @override
  State<InformasiTanamanPage> createState() => _InformasiTanamanPageState();
}

class _InformasiTanamanPageState extends State<InformasiTanamanPage> {
  // Daftar informasi tanaman dalam bentuk list
  final List<TanamanInfo> tanamanList = [
    TanamanInfo(
      title: 'Tanaman Pangan',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      imagePath: 'assets/images/tanamanpangan.jpg',
    ),
    TanamanInfo(
      title: 'Tanaman Obat',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      imagePath: 'assets/images/tanamanobat.jpg',
    ),
    TanamanInfo(
      title: 'Tanaman Hias',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      imagePath: 'assets/images/tanamanhias.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tanamanList.length,
        itemBuilder: (context, index) {
          return buildCard(tanamanList[index], context);
        },
      ),
    );
  }

  // Fungsi untuk membangun card berdasarkan data
  Widget buildCard(TanamanInfo tanaman, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Navigasi ke halaman detail tanaman
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailTanamanPage(tanaman: tanaman),
        ),
      );
    },
    child: Card(
      elevation: 4, // Tambahan bayangan pada card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Sudut membulat
      ),
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0), // Memberi jarak antar card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
            child: Image.asset(
              tanaman.imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanaman.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(color: Colors.black),
                Text(
                  tanaman.description,
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

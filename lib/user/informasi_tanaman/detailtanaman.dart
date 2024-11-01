import 'package:flutter/material.dart';
import 'tanaman.dart'; // Halaman yang menampilkan detail lengkap tanaman
import 'informasi_tanaman.dart';

class DetailTanamanPage extends StatelessWidget {
  final TanamanInfo tanaman; // Jenis tanaman yang dipilih

  DetailTanamanPage({super.key, required this.tanaman});

  // List tanaman pangan, obat, atau hias tergantung pilihan sebelumnya
  final Map<String, List<TanamanInfo>> tanamanDetailMap = {
    'Tanaman Pangan': [
      TanamanInfo(
        title: 'Padi',
        description: 'Tanaman pangan utama di Indonesia.',
        imagePath: 'assets/images/padi.jpg',
      ),
      TanamanInfo(
        title: 'Jagung',
        description: 'Tanaman yang bisa dijadikan bahan pangan dan pakan.',
        imagePath: 'assets/images/jagung.jpg',
      ),
      TanamanInfo(
        title: 'Kedelai',
        description: 'Sumber protein nabati yang sering digunakan.',
        imagePath: 'assets/images/kedelai.jpg',
      ),
    ],
    'Tanaman Obat': [
      TanamanInfo(
        title: 'Jahe',
        description: 'Digunakan untuk obat masuk angin.',
        imagePath: 'assets/images/jahe.jpg',
      ),
      TanamanInfo(
        title: 'Kunyit',
        description: 'Bermanfaat untuk kesehatan pencernaan.',
        imagePath: 'assets/images/kunyit.jpg',
      ),
      TanamanInfo(
        title: 'Temulawak',
        description: 'Dikenal sebagai obat tradisional untuk meningkatkan stamina.',
        imagePath: 'assets/images/temulawak.jpg',
      ),
    ],
    'Tanaman Hias': [
      TanamanInfo(
        title: 'Anggrek',
        description: 'Bunga cantik yang sering dijadikan tanaman hias.',
        imagePath: 'assets/images/anggrek.jpeg',
      ),
      TanamanInfo(
        title: 'Kaktus',
        description: 'Tanaman hias tahan panas yang banyak dijumpai di daerah kering.',
        imagePath: 'assets/images/kaktus.jpeg',
      ),
      TanamanInfo(
        title: 'Bonsai',
        description: 'Tanaman pohon mini yang sering dijadikan dekorasi.',
        imagePath: 'assets/images/bonsai.jpg',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Ambil daftar tanaman sesuai jenis yang dipilih
    final List<TanamanInfo> detailTanamanList = tanamanDetailMap[tanaman.title] ?? [];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: Text(
          tanaman.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemCount: detailTanamanList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman TanamanPage dengan detail tanaman yang dipilih
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TanamanPage(tanaman: detailTanamanList[index]),
                  ),
                );
              },
              child: buildTanamanCard(detailTanamanList[index]),
            );
          },
        ),
      ),
    );
  }

  // Fungsi untuk membangun card tanaman
  Widget buildTanamanCard(TanamanInfo tanaman) {
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
              child: Image.asset(
                tanaman.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tanaman.title,
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

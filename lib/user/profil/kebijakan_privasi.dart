import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Hebatani berkomitmen untuk melindungi privasi dan keamanan data Anda. Dengan menggunakan aplikasi ini, Anda menyetujui kebijakan privasi berikut.

1. Pengumpulan Informasi
Kami mengumpulkan informasi pribadi yang diberikan secara sukarela oleh pengguna, termasuk nama, email, dan informasi lain yang diperlukan untuk menggunakan aplikasi secara optimal.

2. Penggunaan Informasi
Informasi yang dikumpulkan digunakan untuk:
   - Meningkatkan layanan aplikasi.
   - Memberikan pengalaman pengguna yang lebih baik.
   - Menghubungi Anda terkait informasi penting mengenai aplikasi.

3. Perlindungan Data
Kami menggunakan langkah-langkah keamanan yang sesuai untuk melindungi informasi pribadi Anda. Meski demikian, kami tidak dapat menjamin keamanan mutlak dari data yang disimpan atau ditransmisikan secara digital.

4. Berbagi Informasi
Hebatani tidak akan membagikan informasi pribadi Anda kepada pihak ketiga tanpa izin Anda, kecuali jika diwajibkan oleh hukum.

5. Perubahan Kebijakan
Kebijakan privasi ini dapat berubah dari waktu ke waktu. Perubahan akan diberlakukan segera setelah diperbarui di dalam aplikasi. Anda dianjurkan untuk memeriksa kebijakan ini secara berkala.

6. Persetujuan Pengguna
Dengan menggunakan aplikasi Hebatani, Anda menyetujui pengumpulan, penyimpanan, dan penggunaan data Anda sesuai dengan kebijakan privasi ini.

Jika Anda memiliki pertanyaan mengenai kebijakan privasi ini, jangan ragu untuk menghubungi kami.

Terima kasih atas kepercayaan Anda dalam menggunakan Hebatani!
            ''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

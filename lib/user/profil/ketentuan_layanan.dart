import 'package:flutter/material.dart';

class KetentuanLayananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Ketentuan Layanan',
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
Selamat datang di Hebatani! Dengan mengunduh dan menggunakan aplikasi ini, Anda setuju untuk mematuhi ketentuan layanan berikut.

1. Penggunaan Aplikasi
Aplikasi Hebatani disediakan untuk membantu pengguna mengelola informasi dan kegiatan terkait pertanian. Anda diharapkan menggunakan aplikasi ini secara bijak dan sesuai dengan peruntukannya.

2. Informasi Pengguna
Pengguna diharapkan memberikan informasi yang benar dan akurat saat menggunakan layanan ini. Kami tidak bertanggung jawab atas kerugian yang disebabkan oleh informasi yang tidak benar atau tidak akurat yang diberikan oleh pengguna.

3. Privasi
Kami berkomitmen untuk menjaga privasi Anda. Informasi pribadi Anda hanya akan digunakan untuk keperluan aplikasi dan tidak akan dibagikan kepada pihak ketiga tanpa izin Anda, kecuali diwajibkan oleh hukum.

4. Pembaruan dan Perubahan
Hebatani berhak melakukan perubahan atau pembaruan pada fitur, tampilan, dan ketentuan layanan ini tanpa pemberitahuan sebelumnya. Pengguna diharapkan memeriksa ketentuan layanan secara berkala.

5. Batasan Tanggung Jawab
Kami tidak bertanggung jawab atas kerugian atau kerusakan yang mungkin terjadi akibat penggunaan aplikasi ini. Pengguna bertanggung jawab penuh atas tindakan dan keputusan yang diambil berdasarkan informasi dalam aplikasi.

6. Hak Cipta
Semua konten yang terdapat dalam aplikasi ini adalah milik Hebatani. Dilarang menyalin, menyebarkan, atau menggunakan konten tersebut untuk tujuan komersial tanpa izin tertulis dari Hebatani.

Dengan melanjutkan penggunaan aplikasi Hebatani, Anda dianggap telah memahami dan menyetujui ketentuan layanan ini.

Terima kasih telah menggunakan Hebatani!
            ''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

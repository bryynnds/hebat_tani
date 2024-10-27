import 'package:flutter/material.dart';
import 'admin_editartikel.dart';

class Artikel {
  String judul;
  String gambar;
  String deskripsi;

  Artikel({required this.judul, required this.gambar, required this.deskripsi});
}

class AdminBerandaPage extends StatefulWidget {
  const AdminBerandaPage({super.key});

  @override
  State<AdminBerandaPage> createState() => _AdminBerandaPageState();
}

class _AdminBerandaPageState extends State<AdminBerandaPage> {
  List<Artikel> artikelList = [
    Artikel(
      judul: 'Artikel Pertanian 1',
      gambar: 'assets/images/jahe.jpg',
      deskripsi: 'Deskripsi singkat untuk artikel 1.',
    ),
    Artikel(
      judul: 'Artikel Pertanian 2',
      gambar: 'assets/images/jagung.jpg',
      deskripsi: 'Deskripsi singkat untuk artikel 2.',
    ),
  ];

  void editArtikel(int index, String judul, String gambar, String deskripsi) {
    setState(() {
      artikelList[index].judul = judul;
      artikelList[index].gambar = gambar;
      artikelList[index].deskripsi = deskripsi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Beranda'),
      ),
      body: ListView.builder(
        itemCount: artikelList.length,
        itemBuilder: (context, index) {
          final artikel = artikelList[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(
                artikel.gambar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(artikel.judul),
              subtitle: Text(artikel.deskripsi),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditArtikelPage(
                        judul: artikel.judul,
                        gambar: artikel.gambar,
                        deskripsi: artikel.deskripsi,
                        onSave: (editedJudul, editedGambar, editedDeskripsi) {
                          editArtikel(index, editedJudul, editedGambar, editedDeskripsi);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

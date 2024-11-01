import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_tambah_artikel.dart';
import 'admin_editartikel.dart';

class AdminBerandaPage extends StatefulWidget {
  @override
  _AdminBerandaPageState createState() => _AdminBerandaPageState();
}

class _AdminBerandaPageState extends State<AdminBerandaPage> {
  final CollectionReference _articlesCollection = FirebaseFirestore.instance.collection('articles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Data Artikel',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminTambahArtikelPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _articlesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada artikel.'));
          }

          final articles = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              final String id = article.id; // Mengambil ID dokumen artikel
              final String judul = article['judul'];
              final String deskripsi = article['deskripsi'];
              final String gambar = article['gambar'];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Image.network(
                        gambar,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        deskripsi,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              // Konfirmasi penghapusan
                              bool? confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus Artikel'),
                                  content: const Text('Apakah Anda yakin ingin menghapus artikel ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete == true) {
                                await _articlesCollection.doc(id).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Artikel berhasil dihapus')),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8.0),
                          TextButton.icon(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            label: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminEditArtikel(
                                    articleId: id, // Mengirim ID artikel
                                    judul: judul,
                                    deskripsi: deskripsi,
                                    gambar: gambar,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

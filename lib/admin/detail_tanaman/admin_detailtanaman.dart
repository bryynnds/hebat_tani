import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_edittanaman.dart';
import 'admin_tambahtanaman.dart';

class AdminInformasiTanamanPage extends StatefulWidget {
  @override
  _AdminInformasiTanamanPageState createState() => _AdminInformasiTanamanPageState();
}

class _AdminInformasiTanamanPageState extends State<AdminInformasiTanamanPage> {
  // Fungsi untuk menghapus data tanaman dari Firebase
  Future<void> deleteTanaman(String docId) async {
    await FirebaseFirestore.instance.collection('tanaman').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data tanaman berhasil dihapus')),
    );
  }

  // Fungsi untuk menampilkan konfirmasi sebelum menghapus data
  void confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus data tanaman ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteTanaman(docId);
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengambil nama jenis tanaman berdasarkan ID
  Future<String> fetchJenisTanaman(String jenisTanamanId) async {
    final doc = await FirebaseFirestore.instance.collection('jenis_tanaman').doc(jenisTanamanId).get();
    return doc.exists ? doc['title'] : 'Jenis tidak ditemukan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Data Tanaman',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminTambahTanamanPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tanaman').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return FutureBuilder(
                future: fetchJenisTanaman(doc['id_jenis_tanaman']),
                builder: (context, AsyncSnapshot<String> jenisSnapshot) {
                  if (!jenisSnapshot.hasData) return CircularProgressIndicator();
                  return ListTile(
                    title: Text(doc['nama_tanaman']),
                    subtitle: Text('${jenisSnapshot.data}'),
                    leading: Image.network(doc['gambar'], width: 50, height: 50),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditTanamanPage(docId: doc.id),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => confirmDelete(doc.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

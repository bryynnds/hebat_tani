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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tanaman"),
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
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['nama_tanaman']),
                subtitle: Text(doc['deskripsi']),
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
                        ).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Data tanaman berhasil diperbarui')),
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => confirmDelete(doc.id),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

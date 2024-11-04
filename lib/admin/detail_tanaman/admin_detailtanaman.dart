import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_edittanaman.dart';
import 'admin_tambahtanaman.dart';

class AdminInformasiTanamanPage extends StatefulWidget {
  @override
  _AdminInformasiTanamanPageState createState() => _AdminInformasiTanamanPageState();
}

class _AdminInformasiTanamanPageState extends State<AdminInformasiTanamanPage> {
  Future<void> deleteTanaman(String docId) async {
    await FirebaseFirestore.instance.collection('tanaman').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data tanaman berhasil dihapus')),
    );
  }

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

  Future<String> fetchJenisTanaman(String jenisTanamanId) async {
    final doc = await FirebaseFirestore.instance.collection('jenis_tanaman').doc(jenisTanamanId).get();
    return doc.exists ? doc['title'] : 'Jenis tidak ditemukan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              return FutureBuilder(
                future: fetchJenisTanaman(doc['id_jenis_tanaman']),
                builder: (context, AsyncSnapshot<String> jenisSnapshot) {
                  if (!jenisSnapshot.hasData) return CircularProgressIndicator();
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
                            doc['nama_tanaman'],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Image.network(
                            doc['gambar'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            jenisSnapshot.data ?? 'Jenis tidak ditemukan',
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
                                onPressed: () => confirmDelete(doc.id),
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
                                      builder: (context) => AdminEditTanamanPage(docId: doc.id),
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
            }).toList(),
          );
        },
      ),
    );
  }
}

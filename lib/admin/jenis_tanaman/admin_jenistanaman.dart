import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_editjenistanaman.dart';
import 'admin_tambahjenis.dart';

class AdminJenistanaman extends StatefulWidget {
  @override
  _AdminJenistanamanState createState() => _AdminJenistanamanState();
}

class _AdminJenistanamanState extends State<AdminJenistanaman> {
  final CollectionReference _jenisTanamanCollection =
      FirebaseFirestore.instance.collection('jenis_tanaman');

  Future<void> deleteTanaman(String docId) async {
    await _jenisTanamanCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil dihapus')),
    );
  }

  void confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Hapus"),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Data Jenis Tanaman',
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
                MaterialPageRoute(
                    builder: (context) => AdminTambahJenisTanamanPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _jenisTanamanCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada jenis tanaman.'));
          }

          final tanaman = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tanaman.length,
            itemBuilder: (context, index) {
              final doc = tanaman[index];
              final String id = doc.id;
              final String title = doc['title'];
              final String description = doc['description'];
              final String imagePath = doc['imagePath'];

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
                        title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Image.network(
                        imagePath,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
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
                            onPressed: () => confirmDelete(id),
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
                                  builder: (context) =>
                                      AdminEditJenisTanamanPage(docId: id),
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

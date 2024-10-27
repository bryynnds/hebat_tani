import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'input_catatan.dart';
import 'edit_catatan.dart';

class CatatanPertanianPage extends StatelessWidget {
  const CatatanPertanianPage({super.key});

  Future<void> deleteNoteConfirm(BuildContext context, String noteId) async {
    // Menampilkan alert konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Catatan'),
          content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog jika tidak jadi menghapus
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () async {
                // Panggil fungsi hapus catatan
                await FirebaseFirestore.instance.collection('catatan').doc(noteId).delete();
                Navigator.of(context).pop(); // Menutup dialog setelah menghapus
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('catatan').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              return NoteCard(
                title: doc['judul'],
                description: doc['deskripsi'],
                date: doc['tanggal'],
                onTitleTap: () => _onTitleTap(context, doc),
                onDelete: () => deleteNoteConfirm(context, doc.id), // Memanggil fungsi konfirmasi sebelum hapus
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InputCatatanPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTitleTap(BuildContext context, QueryDocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCatatanPage(
          noteId: doc.id,
          title: doc['judul'],
          description: doc['deskripsi'],
          date: doc['tanggal'],
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final VoidCallback onTitleTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.onTitleTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTitleTap,
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(description),
                  const SizedBox(height: 8.0),
                  Text(date, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

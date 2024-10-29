import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_jadwal.dart';

class JadwalKegiatanPage extends StatelessWidget {
  const JadwalKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Kegiatan")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('jadwal').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data();
              return ListTile(
                title: Text(data['judul']),
                subtitle: Text(data['keterangan']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await docs[index].reference.delete();
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditJadwalPage(data: data, id: docs[index].id)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_jadwal.dart';
import 'package:intl/intl.dart';

class JadwalKegiatanPage extends StatelessWidget {
  const JadwalKegiatanPage({super.key});

  Future<void> deleteScheduleConfirm(
      BuildContext context, String scheduleId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Jadwal'),
          content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('jadwal')
                    .doc(scheduleId)
                    .delete();
                Navigator.of(context).pop();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Kembali ke halaman sebelumnya
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Semua Jadwal',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('jadwal').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data();
              Timestamp timestamp = data['tanggal'];
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(timestamp.toDate());

              int colorInt = data['color'];
              Color color = Color(colorInt);

              return ScheduleCard(
                title: data['judul'],
                kegiatan: data['kegiatan'], // Tambahkan kegiatan
                description: data['keterangan'],
                date: formattedDate,
                color: color,
                onCardTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditJadwalPage(data: data, id: docs[index].id),
                    ),
                  );
                },
                onDelete: () => deleteScheduleConfirm(context, docs[index].id),
              );
            },
          );
        },
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String title;
  final String kegiatan; // Tambahkan variabel kegiatan
  final String description;
  final String date;
  final Color color;
  final VoidCallback onCardTap;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.title,
    required this.kegiatan, // Tambahkan variabel kegiatan
    required this.description,
    required this.date,
    required this.color,
    required this.onCardTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onCardTap, // Pindahkan onTap ke GestureDetector yang mengelilingi Card
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lingkaran warna untuk jadwal
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(right: 16.0, top: 5),
              ),
              // Bagian teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kegiatan, // Tampilkan kegiatan
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

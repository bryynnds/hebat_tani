import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahJadwalPage extends StatefulWidget {
  const TambahJadwalPage({super.key});

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  final _judulController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _kegiatan;
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;

  Future<void> _simpanJadwal() async {
    if (_kegiatan != null && _judulController.text.isNotEmpty && _tanggalMulai != null && _tanggalSelesai != null) {
      await FirebaseFirestore.instance.collection('jadwal').add({
        'kegiatan': _kegiatan,
        'judul': _judulController.text,
        'tanggalMulai': Timestamp.fromDate(_tanggalMulai!),
        'tanggalSelesai': Timestamp.fromDate(_tanggalSelesai!),
        'keterangan': _keteranganController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Jadwal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Pilih Kegiatan'),
              items: const [
                DropdownMenuItem(value: 'Membajak', child: Text('Membajak')),
                DropdownMenuItem(value: 'Menyiram', child: Text('Menyiram')),
                DropdownMenuItem(value: 'Menanam', child: Text('Menanam')),
                DropdownMenuItem(value: 'Memanen', child: Text('Memanen')),
              ],
              onChanged: (value) => setState(() => _kegiatan = value),
            ),
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul Pengingat'),
            ),
            TextButton(
              onPressed: () async {
                _tanggalMulai = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                setState(() {});
              },
              child: const Text("Pilih Tanggal Mulai"),
            ),
            TextButton(
              onPressed: () async {
                _tanggalSelesai = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                setState(() {});
              },
              child: const Text("Pilih Tanggal Selesai"),
            ),
            TextFormField(
              controller: _keteranganController,
              decoration: const InputDecoration(labelText: 'Keterangan Kegiatan'),
              maxLines: 4,
            ),
            ElevatedButton(
              onPressed: _simpanJadwal,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}

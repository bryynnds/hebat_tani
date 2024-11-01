import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditJadwalPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  const EditJadwalPage({super.key, required this.data, required this.id});

  @override
  State<EditJadwalPage> createState() => _EditJadwalPageState();
}

class _EditJadwalPageState extends State<EditJadwalPage> {
  final _judulController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _kegiatan;

  @override
  void initState() {
    super.initState();
    _judulController.text = widget.data['judul'];
    _keteranganController.text = widget.data['keterangan'];
    _kegiatan = widget.data['kegiatan'];
  }

  Future<void> _updateJadwal() async {
    await FirebaseFirestore.instance.collection('jadwal').doc(widget.id).update({
      'kegiatan': _kegiatan,
      'judul': _judulController.text,
      'keterangan': _keteranganController.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Jadwal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _kegiatan,
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
            TextFormField(
              controller: _keteranganController,
              decoration: const InputDecoration(labelText: 'Keterangan Kegiatan'),
              maxLines: 4,
            ),
            ElevatedButton(
              onPressed: _updateJadwal,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}

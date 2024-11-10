import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  final _tanggalController = TextEditingController();

  String? _kegiatan;
  DateTime? _tanggal;

  // Warna untuk setiap kegiatan
  final Map<String, Color> kegiatanColors = {
    'Membajak': Colors.red,
    'Menyiram': Colors.blue,
    'Menanam': Colors.green,
    'Memanen': Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    _judulController.text = widget.data['judul'];
    _keteranganController.text = widget.data['keterangan'];
    _kegiatan = widget.data['kegiatan'];
    _tanggal = (widget.data['tanggal'] as Timestamp).toDate();
    _tanggalController.text = DateFormat('dd/MM/yyyy').format(_tanggal!);
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggal = picked;
        _tanggalController.text = DateFormat('dd/MM/yyyy').format(_tanggal!);
      });
    }
  }

  Future<void> _updateJadwal() async {
    if (_kegiatan != null &&
        _judulController.text.isNotEmpty &&
        _tanggal != null) {
      await FirebaseFirestore.instance.collection('jadwal').doc(widget.id).update({
        'kegiatan': _kegiatan,
        'judul': _judulController.text,
        'tanggal': Timestamp.fromDate(_tanggal!),
        'keterangan': _keteranganController.text,
        'color': kegiatanColors[_kegiatan]?.value,
      });
      Navigator.pop(context, true); // Mengirim sinyal sukses saat kembali
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: const Text(
          'Edit Jadwal',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _kegiatan,
                decoration: InputDecoration(
                  labelText: 'Pilih Kegiatan',
                  border: OutlineInputBorder(),
                ),
                items: kegiatanColors.keys.map((kegiatan) {
                  return DropdownMenuItem(
                    value: kegiatan,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: kegiatanColors[kegiatan],
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(kegiatan),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _kegiatan = value),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Pengingat',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _pilihTanggal(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _tanggalController,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Tanggal',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Kegiatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateJadwal,
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

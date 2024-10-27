import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Package untuk format tanggal

class KalenderPengingatPage extends StatefulWidget {
  const KalenderPengingatPage({super.key});

  @override
  State<KalenderPengingatPage> createState() => _KalenderPengingatPageState();
}

class _KalenderPengingatPageState extends State<KalenderPengingatPage> {
  DateTime today = DateTime.now();

  // DateTime untuk tanggal mulai dan selesai
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // Fungsi untuk membuka modal pop-up dari bawah
  void _showAddEventModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              MediaQuery.of(context).viewInsets, // Menyesuaikan dengan keyboard
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pilih Opsi Kegiatan
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Pilih Kegiatan',
                      labelStyle: const TextStyle(fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Membajak', child: Text('Membajak')),
                      DropdownMenuItem(
                          value: 'Menanam', child: Text('Menanam')),
                      DropdownMenuItem(
                          value: 'Menyiram', child: Text('Menyiram')),
                      DropdownMenuItem(
                          value: 'Memanen', child: Text('Memanen')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),

                  // Judul Pengingat
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Judul Pengingat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Mulai
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Mulai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: startDate == null
                          ? ''
                          : DateFormat('yMMMd').format(startDate!),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Selesai
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Selesai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: endDate == null
                          ? ''
                          : DateFormat('yMMMd').format(endDate!),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Keterangan Kegiatan
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Keterangan Kegiatan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Button Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle simpan logika di sini
                        Navigator.pop(context); // Tutup pop-up setelah simpan
                      },
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventModal(context); // Membuka pop-up ketika tombol + ditekan
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TableCalendar(
            locale: "en-US",
            rowHeight: 43,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: _onDaySelected,
          ),
        ),
        Card(
                elevation: 4, // Tambahkan bayangan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 2.0),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Yang akan datang',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 33, 33, 33),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(width: 20.0),
                              Text(
                                'Jadwal 1',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 33, 33, 33),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}

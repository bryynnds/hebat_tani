import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KalenderPengingatPage extends StatefulWidget {
  const KalenderPengingatPage({super.key});

  @override
  State<KalenderPengingatPage> createState() => _KalenderPengingatPageState();
}

class _KalenderPengingatPageState extends State<KalenderPengingatPage> {
  DateTime today = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> events = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('jadwal').get();
    final Map<DateTime, List<Map<String, dynamic>>> fetchedEvents = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      DateTime eventDate = (data['tanggal'] as Timestamp).toDate();
      final formattedDate = DateTime(eventDate.year, eventDate.month, eventDate.day);

      if (fetchedEvents[formattedDate] == null) {
        fetchedEvents[formattedDate] = [];
      }
      fetchedEvents[formattedDate]!.add({
        'title': data['judul'],
        'kegiatan': data['kegiatan'],
        'keterangan': data['keterangan'],
        'color': Color(data['color']),
      });
    }

    setState(() {
      events = fetchedEvents;
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final formattedDay = DateTime(day.year, day.month, day.day);
    return events[formattedDay] ?? <Map<String, dynamic>>[];
  }

  void _showEventsForDay(BuildContext context, DateTime day) {
    final selectedEvents = _getEventsForDay(day);
    if (selectedEvents.isEmpty) return;

    final eventColor = selectedEvents.first['color'] ?? Colors.grey;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Column(
                children: selectedEvents.map((event) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: eventColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(event['title']),
                    subtitle: Text(
                      "Kegiatan: ${event['kegiatan']}\nKeterangan: ${event['keterangan']}",
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  today = selectedDay;
                });
                _showEventsForDay(context, selectedDay);
              },
              eventLoader: (day) => _getEventsForDay(day),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events != null &&
                      events.isNotEmpty &&
                      events.first is Map) {
                    final event = events.first as Map<String, dynamic>;
                    final color = (event['color'] as Color?) ?? Colors.grey;
                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/jadwal_kegiatan');
              if (result == true) {
                await _fetchEvents();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Lihat Semua Jadwal"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/tambah_jadwal');
          if (result == true) {
            await _fetchEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

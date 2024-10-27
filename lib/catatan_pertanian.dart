import 'package:flutter/material.dart';
import 'input_catatan.dart'; // Import halaman input catatan
import 'edit_catatan.dart'; // Import halaman edit catatan

class CatatanPertanianPage extends StatelessWidget {
  const CatatanPertanianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          NoteCard(
            title: "Judul Catatan 1",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            date: "2 - 10 - 2024",
            onTitleTap: () => _onTitleTap(context, "Judul Catatan 1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "2 - 10 - 2024"),
          ),
          NoteCard(
            title: "Judul Catatan 2",
            description:
                "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            date: "2 - 10 - 2024",
            onTitleTap: () => _onTitleTap(context, "Judul Catatan 2", "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "2 - 10 - 2024"),
          ),
          NoteCard(
            title: "Judul Catatan 3",
            description:
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.",
            date: "2 - 10 - 2024",
            onTitleTap: () => _onTitleTap(context, "Judul Catatan 3", "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.", "2 - 10 - 2024"),
          ),
          NoteCard(
            title: "Judul Catatan 3",
            description:
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.",
            date: "2 - 10 - 2024",
            onTitleTap: () => _onTitleTap(context, "Judul Catatan 3", "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.", "2 - 10 - 2024"),
          ),
          NoteCard(
            title: "Judul Catatan 3",
            description:
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.",
            date: "2 - 10 - 2024",
            onTitleTap: () => _onTitleTap(context, "Judul Catatan 3", "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.", "2 - 10 - 2024"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah catatan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InputCatatanPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTitleTap(BuildContext context, String title, String description, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCatatanPage(
          title: title,
          description: description,
          date: date,
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

  const NoteCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTitleTap,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 33, 33, 33),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 33, 33, 33),
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 158, 158, 158)),
              onPressed: () {
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menghapus catatan ini?"),
          actions: [
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Hapus"),
              onPressed: () {
                // Logika hapus catatan
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

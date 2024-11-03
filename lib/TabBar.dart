import 'package:flutter/material.dart';
import 'user/beranda/beranda.dart' as beranda;
import 'user/catatan_pertanian/catatan_pertanian.dart' as catatan;
import 'user/informasi_tanaman/informasi_tanaman.dart' as informasi;
import 'user/kalender_pengingat/kalender_pengingat.dart' as kalender;
import 'user/profil/profil.dart';

// Tambahkan parameter ke constructor TabBarPage
class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  String currentTabTitle = "Beranda";

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);

    // Update judul pertama kali sesuai tab
    updateTabTitle(controller.index);

    // Tambahkan listener untuk mendeteksi perubahan tab langsung ketika swipe dimulai
    controller.addListener(() {
      updateTabTitle(
          controller.index); // Update judul setiap frame selama swipe
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateTabTitle(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentTabTitle = "Beranda";
          break;
        case 1:
          currentTabTitle = "Pengingat Kegiatan";
          break;
        case 2:
          currentTabTitle = "Informasi Tanaman";
          break;
        case 3:
          currentTabTitle = "Catatan Kegiatan";
          break;
        default:
          currentTabTitle = "Beranda";
      }
    });
  }

  // Fungsi untuk mengubah tab ke kalender
  void goToKalender() {
    controller.animateTo(1); // Ganti ke tab kalender
    updateTabTitle(1); // Ubah judul menjadi "Kalender"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 10.0,
        backgroundColor: const Color.fromARGB(255, 46, 125, 50),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            currentTabTitle,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: IconButton(
              onPressed: () {
                // Pindah ke halaman profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profil()),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          beranda.BerandaPage(
              onGoToKalender: goToKalender), // Pass the callback
          const kalender.KalenderPengingatPage(),
          const informasi.InformasiTanamanPage(),
          const catatan.CatatanPertanianPage()
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 53, // Ubah tinggi sesuai keinginan
        width: double.infinity, // Lebar akan menyesuaikan dengan layar
        child: Material(
          elevation: 10.0, // Tambahkan shadow
          color: const Color.fromARGB(255, 46, 125, 50),
          child: TabBar(
            controller: controller,
            onTap: (index) {
              updateTabTitle(index); // Ubah judul ketika tab ditekan
            },
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
            tabs: const [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.calendar_today)),
              Tab(icon: Icon(Icons.grass)),
              Tab(icon: Icon(Icons.note_alt_outlined)),
            ],
          ),
        ),
      ),
    );
  }
}

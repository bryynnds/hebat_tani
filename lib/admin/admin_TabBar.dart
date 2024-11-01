import 'package:flutter/material.dart';
import 'artikel_beranda/admin_beranda.dart';
import 'jenis_tanaman/admin_jenistanaman.dart';
import 'detail_tanaman/admin_detailtanaman.dart';
import 'profil/admin_profil.dart';

class AdminTabBar extends StatefulWidget {
  @override
  _AdminTabBarState createState() => _AdminTabBarState();
}

class _AdminTabBarState extends State<AdminTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            AdminBerandaPage(),
            AdminJenistanaman(),
            AdminInformasiTanamanPage(),
            AdminProfilePage()
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 53,
          width: double.infinity,
          child: Material(
            elevation: 10,
            color: const Color.fromARGB(255, 46, 125, 50),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
              tabs: const [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.grass)),
                Tab(icon: Icon(Icons.grass_rounded)),
                Tab(icon: Icon(Icons.person),)
              ],
            ),
          ),
        ));
  }
}
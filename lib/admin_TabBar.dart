import 'package:flutter/material.dart';
import './admin_beranda.dart';
import './admin_informasitanaman.dart';

class AdminTabBar extends StatefulWidget {
  @override
  _AdminTabBarState createState() => _AdminTabBarState();
}

class _AdminTabBarState extends State<AdminTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          AdminInformasiTanamanPage(),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.green,
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Beranda"),
            Tab(icon: Icon(Icons.grass), text: "Informasi Tanaman"),
          ],
        ),
      ),
    );
  }
}

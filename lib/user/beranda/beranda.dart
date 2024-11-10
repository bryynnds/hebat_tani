import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Artikel {
  final String judul;
  final String gambar;
  final String deskripsi;

  const Artikel({
    required this.judul,
    required this.gambar,
    required this.deskripsi,
  });
}

class BerandaPage extends StatefulWidget {
  final Function onGoToKalender;

  const BerandaPage({super.key, required this.onGoToKalender});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final CollectionReference _articlesCollection = FirebaseFirestore.instance.collection('articles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card "Jadwal Yang akan datang" yang statis
            // GestureDetector(
            //   onTap: () {
            //     widget.onGoToKalender(); // Panggil fungsi ketika Card diklik
            //   },
            //   child: Card(
            //     elevation: 4,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 2.0),
            //     child: const Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Jadwal Yang akan datang',
            //                 style: TextStyle(
            //                   fontFamily: 'Poppins',
            //                   fontSize: 15.0,
            //                   fontWeight: FontWeight.bold,
            //                   color: Color.fromARGB(255, 33, 33, 33),
            //                 ),
            //               ),
            //               SizedBox(height: 10.0),
            //               Row(
            //                 children: [
            //                   CircleAvatar(
            //                     backgroundColor: Colors.grey,
            //                   ),
            //                   SizedBox(width: 20.0),
            //                   Text(
            //                     'Jadwal 1',
            //                     style: TextStyle(
            //                       fontFamily: 'Poppins',
            //                       color: Color.fromARGB(255, 33, 33, 33),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // ListView untuk artikel dari Firestore
            StreamBuilder<QuerySnapshot>(
              stream: _articlesCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var artikelData = snapshot.data!.docs[index];
                    var artikel = Artikel(
                      judul: artikelData['judul'],
                      gambar: artikelData['gambar'],
                      deskripsi: artikelData['deskripsi'],
                    );
                    return buildCard(artikel, context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Artikel artikel, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              artikel.judul,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 33, 33, 33),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Color.fromARGB(255, 33, 33, 33)),
            const SizedBox(height: 5.0),
            Image.network(
              artikel.gambar,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8.0),
            Text(
              artikel.deskripsi,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 33, 33, 33),
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Artikel {
  String judul;
  String gambar;
  String deskripsi;
  Artikel({
    required this.judul,   
    required this.gambar,
    required this.deskripsi,
  });
  factory Artikel.fromDocument(DocumentSnapshot doc) {
    return Artikel(
      judul: doc['judul'],
      gambar: doc['gambar'],
      deskripsi: doc['deskripsi'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'gambar': gambar,
      'deskripsi': deskripsi,
    };
  }
}

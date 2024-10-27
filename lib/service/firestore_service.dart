import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/artikel_model.dart';

class FirestoreService {
  final CollectionReference _artikelCollection =
      FirebaseFirestore.instance.collection('artikel');

  // Menambahkan artikel ke Firestore
  Future<void> addArtikel(Artikel artikel) async {
    try {
      await _artikelCollection.add(artikel.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan artikel: $e');
    }
  }

  // Mengambil semua artikel dari Firestore
  Stream<List<Artikel>> getAllArtikel() {
    return _artikelCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Artikel.fromDocument(doc);
      }).toList();
    });
  }

  // Mengambil artikel berdasarkan ID dokumen
  Future<Artikel> getArtikelById(String id) async {
    try {
      DocumentSnapshot doc = await _artikelCollection.doc(id).get();
      if (doc.exists) {
        return Artikel.fromDocument(doc);
      } else {
        throw Exception('Artikel tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil artikel: $e');
    }
  }

  // Mengupdate artikel berdasarkan ID dokumen
  Future<void> updateArtikel(String id, Artikel artikel) async {
    try {
      await _artikelCollection.doc(id).update(artikel.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate artikel: $e');
    }
  }

  // Menghapus artikel berdasarkan ID dokumen
  Future<void> deleteArtikel(String id) async {
    try {
      await _artikelCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus artikel: $e');
    }
  }
}

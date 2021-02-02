import 'package:cloud_firestore/cloud_firestore.dart';

class ShopProductService {
  String _collection = 'shop';
  String _subCollection = 'product';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getProducts({String shopId}) async* {
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .where('published', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    yield snapshot;
  }
}

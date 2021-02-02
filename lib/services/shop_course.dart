import 'package:cloud_firestore/cloud_firestore.dart';

class ShopCourseService {
  String _collection = 'shop';
  String _subCollection = 'course';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCourses({String shopId}) async* {
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

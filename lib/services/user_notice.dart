import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoticeService {
  String _collection = 'user';
  String _subCollection = 'notice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void updateNotice(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['userId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  Stream<QuerySnapshot> getNotices({String userId}) async* {
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(userId)
        .collection(_subCollection)
        .orderBy('createdAt', descending: true)
        .get();
    yield snapshot;
  }

  Stream<QuerySnapshot> getNoticeRead({String userId}) async* {
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(userId)
        .collection(_subCollection)
        .where('read', isEqualTo: true)
        .get();
    yield snapshot;
  }
}

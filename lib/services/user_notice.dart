import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/user_notice.dart';

class UserNoticeService {
  String _collection = 'user';
  String _subCollection = 'notice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void updateNotice(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  Future<List<UserNoticeModel>> getNotices({String userId}) async {
    List<UserNoticeModel> notices = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(userId)
        .collection(_subCollection)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot notice in snapshot.docs) {
      notices.add(UserNoticeModel.fromSnapshot(notice));
    }
    return notices;
  }

  Future<bool> getNoticeRead({String userId}) async {
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(userId)
        .collection(_subCollection)
        .where('read', isEqualTo: true)
        .get();
    final List<DocumentSnapshot> docs = snapshot.docs;
    if (docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }
}

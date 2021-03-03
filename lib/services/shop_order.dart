import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOrderService {
  String _collection = 'shop';
  String _subCollection = 'order';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String newId({String shopId}) {
    String id = _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .doc()
        .id;
    return id;
  }

  void create(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    _firebaseFirestore
        .collection(_collection)
        .doc(values['shopId'])
        .collection(_subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<int> selectInvoice(
      {String shopId,
      String userId,
      Timestamp startAt,
      Timestamp endAt}) async {
    int totalPrice = 0;
    await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('deliveryAt', descending: true)
        .startAt([startAt])
        .endAt([endAt])
        .get()
        .then((result) {
          result.docs.forEach((doc) {
            totalPrice += doc.data()['totalPrice'];
          });
        });
    return totalPrice;
  }
}

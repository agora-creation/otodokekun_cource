import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/shop_invoice.dart';

class ShopInvoiceService {
  String _collection = 'shop';
  String _subCollection = 'invoice';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<ShopInvoiceModel>> selectList({String shopId}) async {
    List<ShopInvoiceModel> _invoices = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .orderBy('openedAt', descending: true)
        .get();
    for (DocumentSnapshot _invoice in snapshot.docs) {
      _invoices.add(ShopInvoiceModel.fromSnapshot(_invoice));
    }
    return _invoices;
  }
}

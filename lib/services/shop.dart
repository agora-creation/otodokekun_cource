import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/shop.dart';

class ShopService {
  String _collection = 'shop';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<ShopModel> getShop({String shopId}) async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection(_collection).doc(shopId).get();
    return ShopModel.fromSnapshot(snapshot);
  }
}

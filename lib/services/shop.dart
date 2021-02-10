import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/shop.dart';

class ShopService {
  String _collection = 'shop';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> getShopCode({String code}) async {
    String shopId = '';
    await _firebaseFirestore
        .collection(_collection)
        .where('code', isEqualTo: code)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        QueryDocumentSnapshot snapshot = value.docs.first;
        ShopModel shop = ShopModel.fromSnapshot(snapshot);
        shopId = shop.id;
      }
    });
    return shopId;
  }

  Future<ShopModel> getShop({String shopId}) async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection(_collection).doc(shopId).get();
    return ShopModel.fromSnapshot(snapshot);
  }
}

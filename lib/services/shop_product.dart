import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/shop_product.dart';

class ShopProductService {
  String _collection = 'shop';
  String _subCollection = 'product';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<ShopProductModel>> getProducts({String shopId}) async {
    List<ShopProductModel> products = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .where('published', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot product in snapshot.docs) {
      products.add(ShopProductModel.fromSnapshot(product));
    }
    return products;
  }
}

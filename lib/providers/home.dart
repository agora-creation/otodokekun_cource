import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/products.dart';
import 'package:otodokekun_cource/models/shop_product.dart';

class HomeProvider with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  bool isLoading = false;
  List<ProductsModel> products = [];
  DateTime deliveryAt;

  String get token => _token;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void checkProducts({ShopProductModel product}) {
    var contain = products.where((e) => e.id == product.id);
    if (contain.isEmpty) {
      Map data = {
        'id': product.id,
        'name': product.name,
        'image': product.image,
        'unit': product.unit,
        'price': product.price,
        'quantity': 1,
        'totalPrice': product.price * 1,
      };
      ProductsModel _products = ProductsModel.fromMap(data);
      products.add(_products);
    } else {
      products.removeWhere((e) => e.id == product.id);
    }
    notifyListeners();
  }

  void deleteProducts(ProductsModel productsModel) {
    products.removeWhere((e) => e.id == productsModel.id);
    notifyListeners();
  }

  void addQuantity(ProductsModel productsModel) {
    productsModel.quantity += 1;
    productsModel.totalPrice = productsModel.price * productsModel.quantity;
    notifyListeners();
  }

  void removeQuantity(ProductsModel productsModel) {
    if (productsModel.quantity != 1) {
      productsModel.quantity -= 1;
      productsModel.totalPrice = productsModel.price * productsModel.quantity;
      notifyListeners();
    }
  }

  void setDeliveryAt(DateTime selected) {
    deliveryAt = selected;
    notifyListeners();
  }

  Future<void> initFCM() async {
    //iOS PUSH通知の許可確認
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    //FCM tokenの取得
    _firebaseMessaging.getToken().then((token) {
      _token = token;
      print("token: $_token");
    });
    //メッセージ受信時の処理
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_product.dart';

class HomeProvider with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  int tabsIndex = 0;
  bool isLoading = false;
  List<CartModel> cart = [];
  int courseQuantity = 1;
  int totalPrice = 0;

  String get token => _token;

  void changeTabs(int index) {
    tabsIndex = index;
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void checkCart({ShopProductModel product}) {
    var contain = cart.where((e) => e.id == product.id);
    if (contain.isEmpty) {
      Map cartProduct = {
        'id': product.id,
        'name': product.name,
        'image': product.image,
        'unit': product.unit,
        'price': product.price,
        'quantity': 1,
        'totalPrice': product.price * 1,
      };
      CartModel _cartModel = CartModel.fromMap(cartProduct);
      cart.add(_cartModel);
    } else {
      cart.removeWhere((e) => e.id == product.id);
    }
    notifyListeners();
  }

  void addQuantity({CartModel cartModel}) {
    cartModel.quantity += 1;
    cartModel.totalPrice = cartModel.price * cartModel.quantity;
    notifyListeners();
  }

  void removeQuantity({CartModel cartModel}) {
    if (cartModel.quantity != 1) {
      cartModel.quantity -= 1;
      cartModel.totalPrice = cartModel.price * cartModel.quantity;
      notifyListeners();
    }
  }

  void deleteCart({CartModel cartModel}) {
    cart.removeWhere((e) => e.id == cartModel.id);
    notifyListeners();
  }

  void addCourseQuantity() {
    courseQuantity += 1;
    notifyListeners();
  }

  void removeCourseQuantity() {
    if (courseQuantity != 1) {
      courseQuantity -= 1;
      notifyListeners();
    }
  }

  void clearCourseQuantity() {
    courseQuantity = 1;
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

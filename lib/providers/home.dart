import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/services/user_notice.dart';

class HomeProvider with ChangeNotifier {
  UserNoticeService _userNoticeService = UserNoticeService();

  int tabsIndex = 0;

  bool isLoading = false;
  List<CartModel> cart = [];
  int totalPrice = 0;

  void changeTabs(int index) {
    tabsIndex = index;
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Stream<Icon> getNoticeRead({String userId}) async* {
    bool isRead = false;
    isRead = await _userNoticeService.getNoticeRead(userId: userId);
    if (isRead) {
      yield Icon(
        Icons.notifications_active,
        color: Colors.redAccent,
      );
    } else {
      yield Icon(Icons.notifications_none);
    }
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
}

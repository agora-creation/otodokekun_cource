import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();

  String name = '';
  String zip = '';
  String address = '';
  String tel = '';
  List<CartModel> cart = [];
  DateTime deliveryAt = DateTime.now().add(Duration(days: 3));
  TextEditingController remarks = TextEditingController();
  String staff = '';

  void setDeliveryAt(DateTime selected) {
    deliveryAt = selected;
    notifyListeners();
  }

  void create({String shopId, String userId}) {
    List<Map> convertedCart = [];
    int _totalPrice = 0;
    for (CartModel product in cart) {
      convertedCart.add(product.toMap());
      _totalPrice += product.price * product.quantity;
    }
    String id = _shopOrderService.newId(shopId: shopId);
    _shopOrderService.create({
      'id': id,
      'shopId': shopId,
      'userId': userId,
      'name': name,
      'zip': zip,
      'address': address,
      'tel': tel,
      'cart': convertedCart,
      'deliveryAt': deliveryAt,
      'remarks': remarks.text,
      'totalPrice': _totalPrice,
      'staff': staff,
      'shipping': false,
      'createdAt': DateTime.now(),
    });
  }

  void delete({ShopOrderModel order}) {
    _shopOrderService.delete({
      'id': order.id,
      'shopId': order.shopId,
    });
  }

  void updateQuantity({ShopOrderModel order}) {
    List<Map> convertedCart = [];
    int _totalPrice = 0;
    for (CartModel product in cart) {
      convertedCart.add(product.toMap());
      _totalPrice += product.price * product.quantity;
    }
    _shopOrderService.update({
      'id': order.id,
      'shopId': order.shopId,
      'cart': convertedCart,
      'totalPrice': _totalPrice,
    });
  }

  void clearController() {
    remarks.text = '';
  }

  void checkCart({ShopProductModel product}) {
    var contain = cart.where((e) => e.id == product.id);
    if (contain.isEmpty) {
      Map cartMap = {
        'id': product.id,
        'name': product.name,
        'image': product.image,
        'unit': product.unit,
        'price': product.price,
        'quantity': 1,
        'totalPrice': product.price * 1,
      };
      CartModel _cart = CartModel.fromMap(cartMap);
      cart.add(_cart);
    } else {
      cart.removeWhere((e) => e.id == product.id);
    }
    notifyListeners();
  }

  void deleteCart(CartModel cartModel) {
    cart.removeWhere((e) => e.id == cartModel.id);
    notifyListeners();
  }

  void addQuantity(CartModel cartModel) {
    cartModel.quantity += 1;
    cartModel.totalPrice = cartModel.price * cartModel.quantity;
    notifyListeners();
  }

  void removeQuantity(CartModel cartModel) {
    if (cartModel.quantity != 1) {
      cartModel.quantity -= 1;
      cartModel.totalPrice = cartModel.price * cartModel.quantity;
      notifyListeners();
    }
  }
}

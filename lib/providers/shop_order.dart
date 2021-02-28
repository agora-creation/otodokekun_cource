import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopOrderService _shopOrderService = ShopOrderService();

  List<CartModel> tmpCart = [];
  DateTime deliveryAt = DateTime.now().add(Duration(days: 3));
  TextEditingController remarks = TextEditingController();

  void setDeliveryAt({DateTime dateTime}) {
    deliveryAt = dateTime;
    notifyListeners();
  }

  void create({
    String shopId,
    String userId,
    String name,
    String zip,
    String address,
    String tel,
    List<CartModel> cart,
  }) {
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
      'staff': '',
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
    for (CartModel product in tmpCart) {
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

  void setTmpCart({ShopOrderModel order}) {
    tmpCart = order.cart;
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/services/shop_invoice.dart';
import 'package:otodokekun_cource/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopInvoiceService _shopInvoiceService = ShopInvoiceService();
  ShopOrderService _shopOrderService = ShopOrderService();

  List<CartModel> cart = [];
  TextEditingController remarks = TextEditingController();

  DateTime searchOpenedAt = DateTime.now();
  DateTime searchClosedAt = DateTime.now().add(Duration(days: 7));

  void create(
      {String shopId,
      UserModel user,
      List<CartModel> cart,
      DateTime deliveryAt}) {
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
      'userId': user.id,
      'name': user.name,
      'zip': user.zip,
      'address': user.address,
      'tel': user.tel,
      'cart': convertedCart,
      'deliveryAt': deliveryAt,
      'remarks': remarks.text,
      'totalPrice': _totalPrice,
      'staff': user.staff,
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

  void changeSelectDateRage(DateTime openedAt, DateTime closedAt) {
    searchOpenedAt = openedAt;
    searchClosedAt = closedAt;
    notifyListeners();
  }

  Future<int> selectInvoice(
      {String shopId,
      String userId,
      Timestamp startAt,
      Timestamp endAt}) async {
    int _totalPrice = await _shopOrderService.selectInvoice(
      shopId: shopId,
      userId: userId,
      startAt: startAt,
      endAt: endAt,
    );
    return _totalPrice;
  }

  Future<List<ShopInvoiceModel>> selectLitInvoice({String shopId}) async {
    
  }
}

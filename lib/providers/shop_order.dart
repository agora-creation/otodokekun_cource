import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_invoice.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/services/shop_invoice.dart';
import 'package:otodokekun_cource/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopInvoiceService _shopInvoiceService = ShopInvoiceService();
  ShopOrderService _shopOrderService = ShopOrderService();

  List<CartModel> cart = [];
  DateTime deliveryAt = DateTime.now();
  TextEditingController remarks = TextEditingController();
  DateTime searchOpenedAt = DateTime.now();
  DateTime searchClosedAt = DateTime.now().add(Duration(days: 14));

  bool isLoading = false;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void create({UserModel user, List<CartModel> cart}) {
    List<Map> convertedCart = [];
    int _totalPrice = 0;
    for (CartModel product in cart) {
      convertedCart.add(product.toMap());
      _totalPrice += product.price * product.quantity;
    }
    String id = _shopOrderService.newId(shopId: user.shopId);
    _shopOrderService.create({
      'id': id,
      'shopId': user.shopId,
      'userId': user.id,
      'userName': user.name,
      'userZip': user.zip,
      'userAddress': user.address,
      'userTel': user.tel,
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
      'products': convertedCart,
      'totalPrice': _totalPrice,
    });
  }

  void clearController() {
    remarks.text = '';
  }

  void checkCart({ShopProductModel product}) {
    var contain = cart.where((e) => e.id == product.id);
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
      CartModel _cart = CartModel.fromMap(data);
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

  void changeSelectDateRage(DateTime openedAt, DateTime closedAt) {
    searchOpenedAt = openedAt;
    searchClosedAt = closedAt;
    notifyListeners();
  }

  void setDeliveryAt(DateTime selected) {
    deliveryAt = selected;
    notifyListeners();
  }

  Future<int> selectTotalPrice(
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

  Future<List<ShopInvoiceModel>> selectListInvoice({String shopId}) async {
    List<ShopInvoiceModel> _invoices = [];
    await _shopInvoiceService.selectList(shopId: shopId).then((value) {
      _invoices = value;
    });
    return _invoices;
  }
}

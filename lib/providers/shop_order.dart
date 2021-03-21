import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/products.dart';
import 'package:otodokekun_cource/models/shop_invoice.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/services/shop_invoice.dart';
import 'package:otodokekun_cource/services/shop_order.dart';

class ShopOrderProvider with ChangeNotifier {
  ShopInvoiceService _shopInvoiceService = ShopInvoiceService();
  ShopOrderService _shopOrderService = ShopOrderService();

  List<ProductsModel> products = [];
  TextEditingController remarks = TextEditingController();

  DateTime searchOpenedAt = DateTime.now();
  DateTime searchClosedAt = DateTime.now().add(Duration(days: 14));

  void create(
      {String shopId,
      UserModel user,
      List<ProductsModel> products,
      DateTime deliveryAt}) {
    List<Map> convertedProducts = [];
    int _totalPrice = 0;
    for (ProductsModel product in products) {
      convertedProducts.add(product.toMap());
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
      'products': convertedProducts,
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
    List<Map> convertedProducts = [];
    int _totalPrice = 0;
    for (ProductsModel product in products) {
      convertedProducts.add(product.toMap());
      _totalPrice += product.price * product.quantity;
    }
    _shopOrderService.update({
      'id': order.id,
      'shopId': order.shopId,
      'products': convertedProducts,
      'totalPrice': _totalPrice,
    });
  }

  void clearController() {
    remarks.text = '';
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

  void changeSelectDateRage(DateTime openedAt, DateTime closedAt) {
    searchOpenedAt = openedAt;
    searchClosedAt = closedAt;
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

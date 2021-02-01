import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/services/shop_product.dart';

class ShopProductProvider with ChangeNotifier {
  ShopProductService _shopProductService = ShopProductService();

  List<CartModel> cart = [];

  Future<List<ShopProductModel>> getProducts({String shopId}) async {
    List<ShopProductModel> products = [];
    products = await _shopProductService.getProducts(shopId: shopId);
    return products;
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

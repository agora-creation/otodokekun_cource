import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_product_regular.dart';
import 'package:otodokekun_cource/models/tmp.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/services/shop.dart';
import 'package:otodokekun_cource/services/shop_order.dart';
import 'package:otodokekun_cource/services/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _fUser;
  Status _status = Status.Uninitialized;
  ShopService _shopService = ShopService();
  ShopOrderService _shopOrderService = ShopOrderService();
  UserService _userService = UserService();
  ShopModel _shop;
  UserModel _user;

  User get fUser => _fUser;
  Status get status => _status;
  ShopModel get shop => _shop;
  UserModel get user => _user;

  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController shopCode = TextEditingController();

  bool isHidden = false;
  bool isCHidden = false;
  bool isLoading = false;
  String shopId = '';

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  void changeHidden() {
    isHidden = !isHidden;
    notifyListeners();
  }

  void changeCHidden() {
    isCHidden = !isCHidden;
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeShopId(String value) {
    shopId = value;
    notifyListeners();
  }

  Future<bool> signIn({String token}) async {
    if (email.text == null) return false;
    if (password.text == null) return false;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .then((value) {
        _userService.update({
          'id': value.user.uid,
          'token': token,
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp({String token}) async {
    if (name.text == null) return false;
    if (zip.text == null) return false;
    if (address.text == null) return false;
    if (tel.text == null) return false;
    if (email.text == null) return false;
    if (password.text == null) return false;
    if (password.text != cPassword.text) return false;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .then((value) {
        _userService.create({
          'id': value.user.uid,
          'shopId': '',
          'name': name.text.trim(),
          'zip': zip.text.trim(),
          'address': address.text.trim(),
          'tel': tel.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'tmp': [],
          'staff': '',
          'regular': false,
          'token': token,
          'createdAt': DateTime.now(),
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateEmail() async {
    if (name.text == null) return false;
    if (email.text == null) return false;
    try {
      await _auth.currentUser.updateEmail(email.text.trim()).then((result) {
        _userService.update({
          'id': _auth.currentUser.uid,
          'name': name.text.trim(),
          'email': email.text.trim(),
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePassword() async {
    if (password.text == null) return false;
    if (password.text != cPassword.text) return false;
    try {
      await _auth.currentUser
          .updatePassword(password.text.trim())
          .then((result) {
        _userService.update({
          'id': _auth.currentUser.uid,
          'password': password.text.trim(),
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateAddress() async {
    if (zip.text == null) return false;
    if (address.text == null) return false;
    if (tel.text == null) return false;
    try {
      _userService.update({
        'id': _auth.currentUser.uid,
        'zip': zip.text.trim(),
        'address': address.text.trim(),
        'tel': tel.text.trim(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateRegularTrue(
      {List<ShopProductRegularModel> productRegulars}) async {
    try {
      _userService.update({
        'id': _auth.currentUser.uid,
        'regular': true,
      });
      for (ShopProductRegularModel _productRegular in productRegulars) {
        String id = _shopOrderService.newId(shopId: _user.shopId);
        List<Map> cart = [];
        cart.add({
          'id': _productRegular.productId,
          'name': _productRegular.productName,
          'image': _productRegular.productImage,
          'unit': _productRegular.productUnit,
          'price': _productRegular.productPrice,
          'quantity': 1,
          'totalPrice': _productRegular.productPrice,
        });
        _shopOrderService.create({
          'id': id,
          'shopId': _user.shopId,
          'userId': _user.id,
          'userName': _user.name,
          'userZip': _user.zip,
          'userAddress': _user.address,
          'userTel': _user.tel,
          'cart': cart,
          'deliveryAt': _productRegular.deliveryAt,
          'remarks': '',
          'totalPrice': _productRegular.productPrice,
          'staff': _user.staff,
          'shipping': false,
          'createdAt': _productRegular.deliveryAt,
        });
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateRegularFalse() async {
    try {
      _userService.update({
        'id': _auth.currentUser.uid,
        'regular': false,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addTmp({List<TmpModel> tmp}) async {
    if (shopCode.text == null) return false;
    try {
      List<Map> _tmp = [];
      ShopModel _shopModel =
          await _shopService.selectCode(code: shopCode.text.trim());
      for (TmpModel _shop in tmp) {
        if (_shopModel.id == _shop.id) return false;
        _tmp.add(_shop.toMap());
      }
      _tmp.add({
        'id': _shopModel.id,
        'name': _shopModel.name,
        'target': false,
      });
      _userService.update({
        'id': _auth.currentUser.uid,
        'tmp': _tmp,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateShopId({String shopIdDefault, List<TmpModel> tmp}) async {
    if (shopId == '') return false;
    try {
      if (shopIdDefault != '') {
        List<Map> _tmp = [];
        for (TmpModel _shop in tmp) {
          if (shopId == _shop.id) _shop.target = true;
          _tmp.add(_shop.toMap());
        }
        _userService.update({
          'id': _auth.currentUser.uid,
          'tmp': _tmp,
        });
      } else {
        _userService.update({
          'id': _auth.currentUser.uid,
          'shopId': shopId,
        });
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    _shop = null;
    _user = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = '';
    zip.text = '';
    address.text = '';
    tel.text = '';
    email.text = '';
    password.text = '';
    cPassword.text = '';
    shopCode.text = '';
  }

  Future reloadUserModel() async {
    _user = await _userService.select(userId: _fUser.uid);
    if (_user.shopId != '') {
      _shop = await _shopService.select(shopId: _user.shopId);
    }
    notifyListeners();
  }

  Future _onStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _fUser = firebaseUser;
      _status = Status.Authenticated;
      _user = await _userService.select(userId: _fUser.uid);
      if (_user.shopId != '') {
        _shop = await _shopService.select(shopId: _user.shopId);
      }
    }
    notifyListeners();
  }
}

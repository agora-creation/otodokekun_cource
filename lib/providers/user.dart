import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_plan.dart';
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

  ShopModel get shop => _shop;
  UserModel get user => _user;
  Status get status => _status;
  User get fUser => _fUser;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();

  bool isHidden = false;
  bool isCHidden = false;

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
          'shopList': [],
          'name': name.text.trim(),
          'zip': '',
          'address': '',
          'tel': '',
          'email': email.text.trim(),
          'password': password.text.trim(),
          'blacklist': false,
          'staff': '',
          'fixed': false,
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

  Future<bool> updateFixedTrue({List<ShopPlanModel> plans}) async {
    try {
      _userService.update({
        'id': _auth.currentUser.uid,
        'fixed': true,
      });
      for (ShopPlanModel _plan in plans) {
        String id = _shopOrderService.newId(shopId: _user.shopId);
        List<Map> cart = [];
        cart.add({
          'id': _plan.id,
          'name': _plan.name,
          'image': _plan.image,
          'unit': _plan.unit,
          'price': _plan.price,
          'quantity': 1,
          'totalPrice': _plan.price,
        });
        _shopOrderService.create({
          'id': id,
          'shopId': _user.shopId,
          'userId': _user.id,
          'name': _user.name,
          'zip': _user.zip,
          'address': _user.address,
          'tel': _user.tel,
          'cart': cart,
          'deliveryAt': _plan.deliveryAt,
          'remarks': '',
          'totalPrice': _plan.price,
          'staff': _user.staff,
          'shipping': false,
          'createdAt': _plan.deliveryAt,
        });
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateFixedFalse() async {
    try {
      _userService.update({
        'id': _auth.currentUser.uid,
        'fixed': false,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    email.text = '';
    password.text = '';
    cPassword.text = '';
    name.text = '';
    zip.text = '';
    address.text = '';
    tel.text = '';
  }

  Future reloadUserModel() async {
    _user = await _userService.select(userId: _fUser.uid);
    _shop = await _shopService.select(shopId: _user.shopId);
    notifyListeners();
  }

  Future _onStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _fUser = firebaseUser;
      _status = Status.Authenticated;
      _user = await _userService.select(userId: _fUser.uid);
      _shop = await _shopService.select(shopId: _user.shopId);
    }
    notifyListeners();
  }
}

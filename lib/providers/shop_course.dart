import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/services/shop_course.dart';

class ShopCourseProvider with ChangeNotifier {
  ShopCourseService _shopCourseService = ShopCourseService();

  List<ShopCourseModel> courses = [];
  int courseQuantity = 1;

  Future getCourses({String shopId}) async {
    if (shopId != null) {
      courses = await _shopCourseService.getCourses(shopId: shopId);
    }
    notifyListeners();
  }

  void addQuantity() {
    courseQuantity += 1;
    notifyListeners();
  }

  void removeQuantity() {
    if (courseQuantity != 1) {
      courseQuantity -= 1;
      notifyListeners();
    }
  }

  void clearQuantity() {
    courseQuantity = 1;
    notifyListeners();
  }
}

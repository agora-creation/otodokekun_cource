import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/services/shop_course.dart';

class ShopCourseProvider with ChangeNotifier {
  ShopCourseService _shopCourseService = ShopCourseService();

  int courseQuantity = 1;

  Future<List<ShopCourseModel>> getCourses({String shopId}) async {
    List<ShopCourseModel> courses = [];
    courses = await _shopCourseService.getCourses(shopId: shopId);
    return courses;
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

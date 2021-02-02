import 'package:flutter/material.dart';

class ShopCourseProvider with ChangeNotifier {
  int courseQuantity = 1;

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

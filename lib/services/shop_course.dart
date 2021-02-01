import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/shop_course.dart';

class ShopCourseService {
  String _collection = 'shop';
  String _subCollection = 'course';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<ShopCourseModel>> getCourses({String shopId}) async {
    List<ShopCourseModel> courses = [];
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection(_collection)
        .doc(shopId)
        .collection(_subCollection)
        .where('published', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    for (DocumentSnapshot course in snapshot.docs) {
      courses.add(ShopCourseModel.fromSnapshot(course));
    }
    return courses;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/user.dart';

class UserService {
  String _collection = 'user';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void updateUser(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  Future<UserModel> getUser({String userId}) async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection(_collection).doc(userId).get();
    return UserModel.fromSnapshot(snapshot);
  }
}

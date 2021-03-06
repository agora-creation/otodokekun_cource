import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otodokekun_cource/models/tmp.dart';

class UserModel {
  String _id;
  String _shopId;
  String _name;
  String _zip;
  String _address;
  String _tel;
  String _email;
  String _password;
  List<TmpModel> tmp;
  String _staff;
  bool _regular;
  String _token;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  String get staff => _staff;
  bool get regular => _regular;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _zip = snapshot.data()['zip'];
    _address = snapshot.data()['address'];
    _tel = snapshot.data()['tel'];
    _email = snapshot.data()['email'];
    _password = snapshot.data()['password'];
    tmp = _convertTmp(snapshot.data()['tmp']) ?? [];
    _staff = snapshot.data()['staff'];
    _regular = snapshot.data()['regular'];
    _token = snapshot.data()['token'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  List<TmpModel> _convertTmp(List tmp) {
    List<TmpModel> convertedTmp = [];
    for (Map data in tmp) {
      convertedTmp.add(TmpModel.fromMap(data));
    }
    return convertedTmp;
  }
}

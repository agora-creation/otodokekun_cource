import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id;
  String _shopId;
  List<String> _shopList;
  String _name;
  String _zip;
  String _address;
  String _tel;
  String _email;
  String _password;
  bool _blacklist;
  String _staff;
  bool _fixed;
  String _token;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  List<String> get shopList => _shopList;
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get password => _password;
  bool get blacklist => _blacklist;
  String get staff => _staff;
  bool get fixed => _fixed;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _shopList = _convertList(list: snapshot.data()['shopList']) ?? [];
    _name = snapshot.data()['name'];
    _zip = snapshot.data()['zip'];
    _address = snapshot.data()['address'];
    _tel = snapshot.data()['tel'];
    _email = snapshot.data()['email'];
    _password = snapshot.data()['password'];
    _blacklist = snapshot.data()['blacklist'];
    _staff = snapshot.data()['staff'];
    _fixed = snapshot.data()['fixed'];
    _token = snapshot.data()['token'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }

  List<String> _convertList({List list}) {
    List<String> convertedList = [];
    for (String id in list) {
      convertedList.add(id);
    }
    return convertedList;
  }
}

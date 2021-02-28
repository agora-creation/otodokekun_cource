import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPlanModel {
  String _id;
  String _shopId;
  String _name;
  String _image;
  String _unit;
  int _price;
  String _description;
  DateTime _deliveryAt;
  bool _published;
  DateTime _createdAt;

  String get id => _id;
  String get shopId => _shopId;
  String get name => _name;
  String get image => _image;
  String get unit => _unit;
  int get price => _price;
  String get description => _description;
  DateTime get deliveryAt => _deliveryAt;
  bool get published => _published;
  DateTime get createdAt => _createdAt;

  ShopPlanModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()['id'];
    _shopId = snapshot.data()['shopId'];
    _name = snapshot.data()['name'];
    _image = snapshot.data()['image'];
    _unit = snapshot.data()['unit'];
    _price = snapshot.data()['price'];
    _description = snapshot.data()['description'];
    _deliveryAt = snapshot.data()['deliveryAt'].toDate();
    _published = snapshot.data()['published'];
    _createdAt = snapshot.data()['createdAt'].toDate();
  }
}

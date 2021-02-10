class DaysModel {
  String _id;
  String _name;
  String _image;
  String _unit;
  int _price;
  bool _exist;
  DateTime deliveryAt;

  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get unit => _unit;
  bool get exist => _exist;
  int get price => _price;

  DaysModel.fromMap(Map data) {
    _id = data['id'];
    _name = data['name'];
    _image = data['image'];
    _unit = data['unit'];
    _price = data['price'];
    _exist = data['exist'];
    deliveryAt = data['deliveryAt'].toDate();
  }

  Map toMap() => {
        'id': id,
        'name': name,
        'image': image,
        'unit': unit,
        'price': price,
        'exist': exist,
        'deliveryAt': deliveryAt,
      };
}

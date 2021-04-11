class TmpModel {
  String _id;
  String _name;
  bool target;

  String get id => _id;
  String get name => _name;

  TmpModel.fromMap(Map data) {
    _id = data['id'];
    _name = data['name'];
    target = data['target'];
  }

  Map toMap() => {
        'id': id,
        'name': name,
        'target': target,
      };
}

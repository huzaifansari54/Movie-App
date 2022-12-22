class Gener {
  final int? id;
  final String? name;

  Gener({this.id, this.name});

  factory Gener.fromJson(Map map) {
    return Gener(id: map['id'], name: map['name']);
  }
}

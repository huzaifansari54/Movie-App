class Cast {
  final String? name;
  final String? profilePath;
  final String? character;

  Cast({this.name, this.character, this.profilePath});

  factory Cast.fromJson(dynamic map) {
    return Cast(
        name: map['name'],
        profilePath: map["profile_path"],
        character: map['character']);
  }
}

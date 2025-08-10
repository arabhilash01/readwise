class Translator {
  final String? name;

  Translator({this.name});

  factory Translator.fromJson(Map<String, dynamic> json) {
    return Translator(name: json['name']);
  }
}

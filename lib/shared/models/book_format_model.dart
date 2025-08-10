class Formats {
  final String? html;
  final String? epub;
  final String? mobi;
  final String? plainText;
  final String? rdf;
  final String? coverImage;
  final String? zip;

  Formats({this.html, this.epub, this.mobi, this.plainText, this.rdf, this.coverImage, this.zip});

  factory Formats.fromJson(Map<String, dynamic> json) {
    return Formats(
      html: json['text/html'],
      epub: json['application/epub+zip'],
      mobi: json['application/x-mobipocket-ebook'],
      plainText: json['text/plain; charset=us-ascii'],
      rdf: json['application/rdf+xml'],
      coverImage: json['image/jpeg'],
      zip: json['application/octet-stream'],
    );
  }
}

class Post {
  int id;
  DateTime date;
  String link;
  String title;
  String content;
  int authorId;
  int category;
  String thumbnail;

  Post({
    this.authorId,
    this.category,
    this.content,
    this.date,
    this.id,
    this.link,
    this.thumbnail,
    this.title,
  });

  Post.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.date = DateTime.parse(map['date']);
    this.link = map['link'];
    this.title = map['title'];
    this.content = map['content'];
    this.authorId = map['authorId'];
    this.category = map['category'];
    this.thumbnail = map['thumbnail'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date.toString(),
      'link': link,
      'title': title,
      'content': content,
      'authorId': authorId,
      'category': category,
      'thumbnail': thumbnail,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}

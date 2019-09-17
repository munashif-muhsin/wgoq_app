class Post {
  
  final int id;
  final DateTime date;
  final String link;
  final String title;
  final String content;
  final int authorId;
  final int category;
  final String thumbnail;

  Post({
    this.authorId, this.category, this.content, this.date, this.id, this.link, this.thumbnail, this.title
  });

}
import 'package:wgoq_app/modals/category.dart';
import 'package:wgoq_app/modals/post.dart';

class UtilService {
  Post createPost(data) {
    return Post(
        authorId: data['author'],
        category: data['categories'][0],
        content: cleanHtmlContent(data['content']['rendered']),
        date: DateTime.parse(data['date']),
        id: data['id'],
        link: data['link'],
        thumbnail: data['jetpack_featured_media_url'],
        title: data['title']['rendered'],
      );
  }

  String cleanHtmlContent(String data) {
    String filteredString;
    try {
      int firstTabAfterClean = data.indexOf('<p');
      filteredString = data.substring(firstTabAfterClean);
      int lastDirectionRTLLocation = filteredString.indexOf('direction: rtl');
      filteredString = filteredString.substring(0, lastDirectionRTLLocation);
      int lastClosingPTag = filteredString.lastIndexOf('</p>');
      filteredString = filteredString.substring(0, lastClosingPTag);
    } catch (e) {
      print('html conversion failed with $data');
      filteredString = data;
    }
    return filteredString;
  }

  createCategory(data) {
    return Category(id: data['id'], name: data['name']);
  }
}

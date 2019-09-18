import 'package:wgoq_app/modals/category.dart';
import 'package:wgoq_app/modals/post.dart';

import 'database_helpers.dart';

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

  Future<Post> getPostFromBookmark() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 42374;
    Post post = await helper.queryPost(rowId);
    if (post == null) {
      return null;
    } else {
      return post;
    }
  }

  Future<bool> removeBookmark(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    try {
        bool status = await helper.deleteWithId(id);
        return status;
      } catch (e) {
        print(e);
        return false;
      }
  }

  Future<List<Post>> getBookmarks() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Post> posts = await helper.queryAll();
    if(posts != null) {
      return posts;
    } else {
      return [];
    }
  }

  Future<bool> saveBookmark(Post post) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    try {
      int id = await helper.insert(post);
      print('inserted row: $id');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

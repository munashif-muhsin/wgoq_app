import 'dart:convert' as convert;
import 'package:wgoq_app/modals/post.dart';
import 'package:http/http.dart' as http;
import 'package:wgoq_app/services/categories.dart';

class PostService {
  

  List<Post> posts;

  Future<List<Post>> getPosts([int pageNumber = 1]) async {
    List<Post> _posts = [];
    final String url = 'https://www.wgoqatar.com/wp-json/wp/v2/posts?page=$pageNumber';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((item) => _posts.add(_createPost(item)));
      posts = _posts;
      return _posts;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }

  Future getHomePageContent() async {
    Map homePageContent = {
      'latest': null,
      'categories': null,
      'posts': null
    };
    var result = await Future.wait([
      getPosts(),
      CategoryService().getCategories()
    ]);
    homePageContent['latest'] = result[0].sublist(0, 5);
    homePageContent['posts'] = result[0].sublist(5, 10);
    homePageContent['categories'] = result[1];
    return homePageContent;
  }

  Post _createPost(data) {
    return Post(
      authorId: data['author'],
      category: data['categories'][0],
      content: _cleanHtmlContent(data['content']['rendered']),
      date: DateTime.parse(data['date']),
      id: data['id'],
      link: data['link'],
      thumbnail: data['jetpack_featured_media_url'],
      title: data['title']['rendered']
    );
  }

  String _cleanHtmlContent(String data) {
    String filteredString;
    int firstTabAfterClean = data.indexOf('<p>');
    filteredString = data.substring(firstTabAfterClean);
    int lastDirectionRTLLocation = filteredString.indexOf('direction: rtl');
    filteredString = filteredString.substring(0, lastDirectionRTLLocation);
    int lastClosingPTag = filteredString.lastIndexOf('</p>');
    filteredString = filteredString.substring(0, lastClosingPTag);
    return filteredString;
  }

}
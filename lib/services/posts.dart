import 'dart:convert' as convert;
import 'package:wgoq_app/modals/post.dart';
import 'package:http/http.dart' as http;
import 'package:wgoq_app/services/categories.dart';
import 'package:wgoq_app/services/util.dart';

class PostService {
  List<Post> posts;
  UtilService _utilService = UtilService();

  Future<List<Post>> getBookmarks() async {

    

  }

  Future<List<Post>> search(String value) async {
    List<Post> _posts = [];
    final String url =
        'https://www.wgoqatar.com/wp-json/wp/v2/search?search=$value';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = convert.jsonDecode(response.body);
      var futures = jsonResponse.map((item) {
        return http.get(
          'https://www.wgoqatar.com/wp-json/wp/v2/posts/${item['id']}',
        );
      });
      List responses = await Future.wait(futures);
      for (var i = 0; i < responses.length; i++) {
        var jsonResponse = convert.jsonDecode(responses[i].body);
        _posts.add(_utilService.createPost(jsonResponse));
      }
      return _posts;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }

  Future<List<Post>> getPosts([int pageNumber = 1]) async {
    List<Post> _posts = [];
    final String url =
        'https://www.wgoqatar.com/wp-json/wp/v2/posts?page=$pageNumber';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((item) => _posts.add(_utilService.createPost(item)));
      posts = _posts;
      return _posts;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }

  Future<List<Post>> getPostsByCategory(int categoryId, [int pageNumber = 1]) async {
    List<Post> _posts = [];
    final String url =
        'https://www.wgoqatar.com/wp-json/wp/v2/posts?categories=$categoryId&&page=$pageNumber';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((item) => _posts.add(_utilService.createPost(item)));
      posts = _posts;
      return _posts;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }

  Future getHomePageContent() async {
    Map homePageContent = {'latest': null, 'categories': null, 'posts': null};
    var result =
        await Future.wait([getPosts(), CategoryService().getCategories()]);
    homePageContent['latest'] = result[0].sublist(0, 5);
    homePageContent['posts'] = result[0].sublist(5, 10);
    homePageContent['categories'] = result[1];
    return homePageContent;
  }


}

import 'package:wgoq_app/modals/category.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/services/util.dart';

class CategoryService {
  List<Category> categories = [];
  UtilService _utilService = UtilService();

  Future<List<Category>> getCategories([pageNumber = 1]) async {
    List<Category> _categories = [];
    final String url =
        'https://www.wgoqatar.com/wp-json/wp/v2/categories?page=$pageNumber';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach(
          (item) => _categories.add(_utilService.createCategory(item)));
      categories = _categories;
      return categories;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }

  Future<List<Map>> getCategoryPageContent([pageNumber = 1]) async {
    List<Map> result = [];

    List<Category> categories = await getCategories(pageNumber);
    Iterable<Future<http.Response>> futures = categories.map((Category item) {
      return http.get(
        'https://www.wgoqatar.com/wp-json/wp/v2/posts?categories=${item.id}',
      );
    });

    List<dynamic> responses = await Future.wait(futures);

    for (var i = 0; i < responses.length; i++) {
      var jsonResponse = convert.jsonDecode(responses[i].body);
      List<Post> posts = [];
      jsonResponse.forEach((item) => posts.add(_utilService.createPost(item)));
      result.add({'category': categories[i], 'posts': posts});
    }

    return result;
  }
}

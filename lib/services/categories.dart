import 'package:wgoq_app/modals/category.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CategoryService {

  List<Category> categories = [];
  
  Future<List<Category>> getCategories([pageNumber = 1]) async {
    List<Category> _categories = [];
    final String url = 'https://www.wgoqatar.com/wp-json/wp/v2/categories?page=$pageNumber';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((item) => _categories.add(_createCategory(item)));
      categories = _categories;
      return categories;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return [];
    }
  }

  _createCategory(data) {
    return Category(
      id: data['id'],
      name: data['name']
    );
  }

}
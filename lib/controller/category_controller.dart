// category_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryController {
  Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/categories'),
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      if (data is List) {
        return data.map<String>((element) {
          if (element is String) {
            return element;
          } else if (element is Map<String, dynamic> &&
              element.containsKey('name')) {
            return element['name'].toString();
          } else {
            return element.toString();
          }
        }).toList();
      } else if (data is Map<String, dynamic> &&
          data.containsKey('categories')) {
        final List<dynamic> list = data['categories'];
        return list.map<String>((element) => element.toString()).toList();
      } else {
        throw Exception("Unexpected data format");
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

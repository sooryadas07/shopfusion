// category_list_widget.dart
import 'package:flutter/material.dart';
import '../controller/category_controller.dart';

class CategoryListWidget extends StatelessWidget {
  final CategoryController controller = CategoryController();

  // Format a string like "home-decoration" → "Home Decoration"
  String formatCategory(String category) {
    return category
        .split('-')
        .map((word) => word.isNotEmpty ? (word[0].toUpperCase() + word.substring(1)) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: FutureBuilder<List<String>>(
        future: controller.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final displayName = formatCategory(category);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Chip(
                  label: Text(
                    displayName,
                    style: TextStyle(fontSize: 14),
                  ),
                  backgroundColor: Colors.blue.shade100,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

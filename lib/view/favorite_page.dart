import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  void _removeFavorite(int id) async {
    final box = Hive.box('appBox');
    List favs = box.get('favorites', defaultValue: []);
    favs.removeWhere((item) => item['id'] == id);
    await box.put('favorites', favs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('appBox');
    final List favs = box.get('favorites', defaultValue: []);
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body:
          favs.isEmpty
              ? Center(child: Text('No favorite products yet.'))
              : ListView.separated(
                itemCount: favs.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final item = favs[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          item['image'] != null &&
                                  item['image'].toString().isNotEmpty
                              ? Image.network(
                                item['image'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                              : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${item['price']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D5BFF),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _removeFavorite(item['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

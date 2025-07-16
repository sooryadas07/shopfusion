import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'cart_page.dart';
import '../model/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  static const double gst = 185.0;
  bool isFavorite = false;

  double get totalAmount => (widget.product.price + gst);

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    final box = Hive.box('appBox');
    List favs = box.get('favorites', defaultValue: []);
    if (isFavorite) {
      favs.add({
        'id': widget.product.id,
        'title': widget.product.title,
        'price': widget.product.price,
        'image': widget.product.thumbnail,
      });
    } else {
      favs.removeWhere((item) => item['id'] == widget.product.id);
    }
    await box.put('favorites', favs);
  }

  void _addToCart() async {
    final box = Hive.box('appBox');
    List cart = box.get('cart', defaultValue: []);
    final cartItem = {
      'id': widget.product.id,
      'title': widget.product.title,
      'price': widget.product.price,
      'quantity': 1,
      'image': widget.product.thumbnail,
    };
    int index = cart.indexWhere((item) => item['id'] == widget.product.id);
    if (index != -1) {
      cart[index]['quantity'] += 1;
    } else {
      cart.add(cartItem);
    }
    await box.put('cart', cart);
    Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Product Image
          Container(
            margin: EdgeInsets.all(16),
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                widget.product.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF22223B),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Text(
                  '\u20B9${widget.product.price}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D5BFF),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // Bottom Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\u20B9${(widget.product.price).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22223B),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'GST: \u20B9${gst.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6D5BFF),
                        padding: EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

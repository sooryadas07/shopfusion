import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _removeItem(int id) async {
    final box = Hive.box('appBox');
    List cartItems = box.get('cart', defaultValue: []);
    cartItems.removeWhere((item) => item['id'] == id);
    await box.put('cart', cartItems);
    setState(() {});
  }

  void _changeQuantity(int id, int delta) async {
    final box = Hive.box('appBox');
    List cartItems = box.get('cart', defaultValue: []);
    int index = cartItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      int newQty = cartItems[index]['quantity'] + delta;
      if (newQty > 0) {
        cartItems[index]['quantity'] = newQty;
        await box.put('cart', cartItems);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('appBox');
    final List cartItems = box.get('cart', defaultValue: []);
    double subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double gst = subtotal * 0.18;
    double total = subtotal + gst;

    return Scaffold(
      appBar: AppBar(title: Text('My Cart')),
      body: Column(
        children: [
          Expanded(
            child:
                cartItems.isEmpty
                    ? Center(child: Text('Your cart is empty.'))
                    : ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
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
                                          (context, error, stackTrace) =>
                                              Container(
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
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Color(0xFF6D5BFF),
                                ),
                                onPressed:
                                    () => _changeQuantity(item['id'], -1),
                              ),
                              Text(
                                '${item['quantity']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Color(0xFF6D5BFF),
                                ),
                                onPressed: () => _changeQuantity(item['id'], 1),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D5BFF),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _removeItem(item['id']),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          if (cartItems.isNotEmpty)
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(fontSize: 16)),
                      Text(
                        '₹${subtotal.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GST (18%)', style: TextStyle(fontSize: 16)),
                      Text(
                        '₹${gst.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D5BFF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: cartItems.isEmpty ? null : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6D5BFF),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

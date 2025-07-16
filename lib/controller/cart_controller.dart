import 'package:flutter/material.dart';
import '../model/product.dart';

class CartController with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _cartItems.contains(product);
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }
}

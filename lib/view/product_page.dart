import 'package:flutter/material.dart';
import '../controller/product_controller.dart';
import '../model/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/category_list.dart';
import 'carousel_network_widget.dart';
import 'category_row_widget.dart';
import 'product_grid_widget.dart';
import 'package:hive/hive.dart';
import 'favorite_page.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController controller = ProductController();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await controller.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts =
          _allProducts
              .where((product) => product.title.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Carousel Slider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: CarouselNetworkWidget(
              imageUrls: [
                'https://t4.ftcdn.net/jpg/00/63/83/29/360_F_63832907_SA64nRfoIU8qaPKDkcYT7Ax2T0eVFJDY.jpg',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSryDj0JDpferYfjpSrlF34qpTewPLmyFNH5w&s',
                'https://assets.aboutamazon.com/dims4/default/7cf67dc/2147483647/strip/true/crop/1279x720+0+0/resize/1240x698!/quality/90/?url=https%3A%2F%2Famazon-blogs-brightspot.s3.amazonaws.com%2Fa1%2F9d%2F55fb16484979b0190a96f2a76337%2Famazon-fresh-grocery-service-lead.jpg',
              ],
              height: 180.0,
              autoPlay: true,
              borderRadius: 20.0,
            ),
          ),
          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: CategoryListWidget(),
          ),
          // Products Grid
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text("Error: $_error"))
                    : ProductGridWidget(products: _filteredProducts),
          ),
        ],
      ),
    );
  }
}

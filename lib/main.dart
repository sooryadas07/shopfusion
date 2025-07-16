import 'package:flutter/material.dart';
import 'package:shopfusion/view/login_page.dart';
import 'package:shopfusion/view/product_page.dart';
import 'package:shopfusion/controller/cart_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopfusion/widgets/bottom_nav_widget.dart';
import 'package:shopfusion/view/cart_page.dart';
import 'package:shopfusion/view/favorite_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopFusion',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home:  SplashScreen(),
    );
  }
}


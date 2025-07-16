// import 'package:flutter/material.dart';
//
// class Category {
//   final String name;
//   final IconData icon;
//   Category({required this.name, required this.icon});
// }
//
// class CategoryRowWidget extends StatelessWidget {
//   final List<Category> categories;
//   final double avatarRadius;
//   final double iconSize;
//
//   const CategoryRowWidget({
//     Key? key,
//     required this.categories,
//     this.avatarRadius = 24.0,
//     this.iconSize = 28.0,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: avatarRadius * 2.5,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children:
//             categories
//                 .map(
//                   (cat) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: avatarRadius,
//                           child: Icon(cat.icon, size: iconSize),
//                         ),
//                         SizedBox(height: 4),
//                         Text(cat.name, style: TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                 )
//                 .toList(),
//       ),
//     );
//   }
// }

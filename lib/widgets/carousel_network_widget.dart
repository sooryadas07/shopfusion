import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselNetworkWidget extends StatelessWidget {
  final List<String> imageUrls;
  final double height;
  final bool autoPlay;
  final double borderRadius;

  const CarouselNetworkWidget({
    Key? key,
    required this.imageUrls,
    this.height = 160.0,
    this.autoPlay = true,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: autoPlay,
        enlargeCenterPage: true,
      ),
      items:
          imageUrls.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Image.network(
                    url,
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
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}

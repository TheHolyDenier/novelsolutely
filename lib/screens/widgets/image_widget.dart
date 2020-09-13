import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String url;

  ImageWidget({this.url});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: url != null
          ? FadeInImage.assetNetwork(
              image: url,
              placeholder: 'assets/images/dictionary.jpg',
            )
          : Image.asset('assets/images/dictionary.jpg'),
    );
  }
}

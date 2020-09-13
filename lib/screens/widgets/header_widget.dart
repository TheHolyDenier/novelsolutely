import 'package:flutter/material.dart';

//SCREENS && WIDGETS
import './image_widget.dart';

//MODELS

//UTILS
import '../../utils/colors.dart';

class HeaderWidget extends StatefulWidget {
  final String name;
  final List<String> images;
  final double height, width;

  HeaderWidget({this.name, this.images, this.height, this.width});

  @override
  _HeaderWidgetState createState() =>
      _HeaderWidgetState(this.name, this.images, this.height, this.width);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final String _name;
  final List<String> _images;
  final double _height, _width;

  _HeaderWidgetState(this._name, this._images, this._height, this._width);

  final double _max = 15, _min = 10;
  final _controller = PageController(initialPage: 0);
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _name,
      child: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value) {
                setState(() {
                  _index = value;
                });
              },
              controller: _controller,
              children: [
                if (_images != null)
                  for (var image in _images)
                    Container(
                      child: ImageWidget(url: image),
                      width: _width,
                      height: _height,
                    ),
              ],
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_images != null)
                    for (int n
                        in Iterable<int>.generate(_images.length).toList())
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        width: n == _index ? _max : _min,
                        height: n == _index ? _max : _min,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Palette.black,
                                blurRadius: 1.0,
                                spreadRadius: 0.0,
                                offset: Offset(1.0, 1.0))
                          ],
                        ),
                      )
                  // Icon(n == _index
                  //     ? Icons.trip_origin
                  //     : Icons.panorama_fish_eye)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

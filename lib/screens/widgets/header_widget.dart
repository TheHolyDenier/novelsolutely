import 'package:flutter/material.dart';

//SCREENS && WIDGETS
import './image_widget.dart';

//UTILS
import '../../utils/colors.dart';

class HeaderWidget extends StatefulWidget {
  final String name;
  final List<String> images;
  final double height, width;
  final GlobalKey<HeaderWidgetState> key;

  HeaderWidget({this.name, this.images, this.height, this.width, this.key});

  @override
  HeaderWidgetState createState() => HeaderWidgetState(
      this.name, this.images, this.height, this.width, this.key);
}

class HeaderWidgetState extends State<HeaderWidget> {
  final String _name;
  List<String> _images;
  final double _height, _width;
  GlobalKey<HeaderWidgetState> key;

  HeaderWidgetState(
      this._name, this._images, this._height, this._width, this.key);

  final double _max = 15, _min = 10;
  final _controller = PageController(initialPage: 0);
  int _index = 0;

  @override
  Widget build(BuildContext context) => Hero(
      tag: _name,
      child: Container(
        width: _width,
        height: _height,
        child: _images != null && _images.isNotEmpty
            ? _setImageSlider()
            : ImageWidget(),
      ),
    );

  Widget _setImageSlider() => Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                _index = value;
              });
            },
            controller: _controller,
            children: [
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
                  for (int n in Iterable<int>.generate(_images.length).toList())
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
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
                    ),
              ],
            ),
          )
        ],
      );

  void updateImages(List<String> images) {
    setState(() {
      _images = images;
    });
  }
}

import 'package:flutter/material.dart';

//UTILS
import '../../utils/strings.dart';

typedef TagCallback = void Function(List<String> selected);

class TagWidget extends StatefulWidget {
  // final List<String> _tags;
  final TagCallback callback;
  final GlobalKey<TagWidgetState> key;

  TagWidget({@required this.callback, @required this.key});

  @override
  TagWidgetState createState() =>
      TagWidgetState(callback: this.callback, key: this.key);
}

class TagWidgetState extends State<TagWidget> {
  List<String> _tagsList = [];
  List<String> _selected = [];
  TagCallback callback;
  final GlobalKey<TagWidgetState> key;

  TagWidgetState({this.callback, this.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(Strings.filters),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: _setTags(),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.select_all),
                  onPressed: () => _select(true),
                ),
                IconButton(
                  icon: Icon(Icons.tab_unselected),
                  onPressed: () => _select(false),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Container _setTags() {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: [
          for (var tag in _tagsList)
            FilterChip(
              selectedColor: Theme.of(context).accentColor,
              showCheckmark: false,
              selected: _selected.contains(tag),
              onSelected: (bool value) {
                setState(() {
                  if (!value) {
                    _selected.removeWhere((String name) => name == tag);
                  } else {
                    _selected.add(tag);
                  }
                  callback(_selected);
                });
              },
              label: Text(tag),
            )
        ],
      ),
    );
  }

  void _select(bool tagsState) {
    if (tagsState) {
      _selected = [...List.from(_tagsList)];
    } else {
      _selected.length = 0;
    }
    callback(_selected);
    setState(() {});
  }

  void updateTags(List<String> newTags) {
    setState(() {
      _tagsList = [...newTags];
      _selected = [...newTags];
      callback(_selected);
    });
  }
}

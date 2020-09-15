import 'package:flutter/material.dart';

//UTILS
import '../../utils/strings.dart';

typedef SelectCallback = void Function(List<String> selected);

class TagWidget extends StatefulWidget {

  final List<String> _tags;
  final SelectCallback setFilters;

  TagWidget(this._tags, {this.setFilters});

  @override
  _TagWidgetState createState() =>
      _TagWidgetState(this._tags, setFilters: this.setFilters);
}

class _TagWidgetState extends State<TagWidget> {
  List<String> _tags, _selected;
  SelectCallback setFilters;

  _TagWidgetState(this._tags, {this.setFilters});


  @override
  Widget build(BuildContext context) {
    if (_selected == null) _selected = List.from(_tags);
    return ExpansionTile(
      title: Text(Strings.filters),
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: _setTags(),
              ),
            ),
            Column(
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
          for (var tag in _tags)
            FilterChip(
              selectedColor: Theme.of(context).accentColor,
              showCheckmark: false,
              selected: _selected.contains(tag),
              onSelected: (bool value) {
                setState(() {
                  if (!value) {
                    _selected.removeWhere((String name) {
                      return name == tag;
                    });
                  } else {
                    _selected.add(tag);
                  }
                  setFilters(_selected);
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
      _selected = List.from(_tags);
    } else {
      _selected.length = 0;
    }
    setFilters(_selected);
    setState(() {});
  }
}

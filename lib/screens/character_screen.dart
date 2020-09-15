import 'package:flutter/material.dart';

//LIBRARIES
import 'package:flutter_tags/flutter_tags.dart';
import 'package:novelsolutely/models/dictionary.dart';
import 'package:novelsolutely/utils/data.dart';

//SCREENS && WIDGETS
import './widgets/header_widget.dart';
import './widgets/milestone_widget.dart';

//MODELS
import '../models/character.dart';
import '../models/path_id.dart';

//UTILS
import '../utils/strings.dart';
import '../utils/dimens.dart';
import '../utils/colors.dart';

class CharacterScreen extends StatefulWidget {
  static const route = '/character';

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  Character _character;
  final _tagStateKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    PathId pathId = ModalRoute.of(context).settings.arguments;
    if (_character == null) _character = (Data.box.get(pathId.dictionaryId) as Dictionary).characters.firstWhere((element) => element.id == pathId.elementId);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        title: Text(Strings.formatName(_character.name)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(
              name: _character.name,
              images: _character.imagePath ?? null,
              height: size.height / 3,
              width: size.width,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: Dimens.small_vertical_margin,
                horizontal: Dimens.horizontal_margin,
              ),
              child: Text(
                _character.summary,
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: Dimens.small_vertical_margin,
                horizontal: Dimens.horizontal_margin,
              ),
              child: ExpansionTile(
                title: Text(Strings.filters),
                children: [
                  Tags(
                      key: _tagStateKey,
                      textField: TagsTextField(
                        autofocus: false,
                        hintText: Strings.add_tag,
                        width: size.width,
                        onSubmitted: (String str) {
                          setState(() {
                            if (!Strings.containsCaseInsensitive(
                                str, _character.tags)) _character.tags.add(str);
                          });
                        },
                      ),
                      itemCount: _character.tags.length,
                      itemBuilder: (int index) {
                        final item = _character.tags[index];
                        return ItemTags(
                          activeColor: Palette.purple,
                          index: index,
                          title: item,
                          key: Key(item),
                          combine: ItemTagsCombine.withTextBefore,
                          removeButton: ItemTagsRemoveButton(
                            backgroundColor: Palette.white,
                            color: Palette.purple,
                            onRemoved: () {
                              removeItem(index);
                              return true;
                            },
                          ),
                          onPressed: (item) => removeItem(index), // OR null,
                        );
                      }),
                ],
              ),
            ),
            MilestoneWidget(_character.personality),
            MilestoneWidget(_character.appearance),
            if (_character.milestones != null)
              for (final category in _character.milestones)
                MilestoneWidget(category),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label: Text(Strings.add_category.toUpperCase())),
    );
  }

  void removeItem(int index) {
    setState(() {
      _character.tags.removeAt(index);
    });
  }
}

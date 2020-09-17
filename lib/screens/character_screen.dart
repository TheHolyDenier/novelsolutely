import 'package:flutter/material.dart';

//LIBRARIES
import 'package:flutter_tags/flutter_tags.dart';
import 'package:novelsolutely/screens/widgets/header_widget.dart';

import './dialogs/generic_input_dialog.dart';
import './dialogs/images_input_dialog.dart';

//SCREENS && WIDGETS
import './widgets/milestone_widget.dart';

//MODELS
import '../models/character.dart';
import '../models/dictionary.dart';
import '../models/path_id.dart';
import '../utils/colors.dart';
import '../utils/data.dart';
import '../utils/dialog_anim.dart';
import '../utils/dimens.dart';

//UTILS
import '../utils/strings.dart';

class CharacterScreen extends StatefulWidget {
  static const route = '/character';

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final _tagStateKey = GlobalKey<TagsState>();
  Character _character;
  Dictionary _dictionary;

  GlobalKey<HeaderWidgetState> _keyChild = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PathId pathId = ModalRoute.of(context).settings.arguments;
    _setCharacter(pathId);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        title: Text(Strings.formatName(_character.name)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () => DialogAnimation.openDialog(
              context,
              GenericInputDialog(
                _character.toGeneric(),
                isCharacter: true,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_a_photo_outlined),
            onPressed: () => DialogAnimation.openDialog(
              context,
              ImagesInputDialog(_character.toGeneric()),
            ).then((value) => _saveImages(value)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(
              name: _character.name,
              images: _character.imagePath ?? null,
              height: size.height / 3,
              width: size.width,
             key: _keyChild
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
                // TODO:  extract + callback
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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, label: Text(Strings.add_category.toUpperCase())),
    );
  }

  void _setCharacter(PathId pathId) {
    if (_character == null) {
      _dictionary = (Data.box.get(pathId.dictionaryId) as Dictionary);
      _character = _dictionary.characters
          .firstWhere((element) => element.id == pathId.elementId);
    }
  }

  void removeItem(int index) {
    setState(() {
      _character.tags.removeAt(index);
    });
  }

  _saveImages(List<String> images) {
    if (images != null && images.length > 0) {
      setState(() {

      _character.imagePath = [...images];
      _dictionary.save();
      });
    }
    _keyChild.currentState.updateImages(images);
  }
}

import 'package:flutter/material.dart';
//SCREENS
import '../character_screen.dart';

//MODELS
import '../../models/generic.dart';
import '../../utils/dimens.dart';
import '../../models/path_id.dart';

//WIDGETS
import '../widgets/image_widget.dart';

class CharacterListWidget extends StatelessWidget {
  final String _dictionaryId;
  final List<Generic> _filtered;

  CharacterListWidget(this._dictionaryId, this._filtered);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        var character = _filtered[index];
        return Column(
          children: [
            if (index == 0 || character.name[0] != _filtered[index - 1].name[0])
              Column(
                children: [
                  if (index != 0)
                    Container(
                      height: 20,
                    ),
                  Text(character.name[0],
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
            Card(
              margin:
                  EdgeInsets.symmetric(vertical: Dimens.small_vertical_margin),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Hero(
                          tag: character.name,
                          child: Container(
                            width: 50,
                            height: 50,
                            child: ClipOval(
                              child: ImageWidget(
                                  url: character.imagePath != null
                                      ? character.imagePath
                                      : ''),
                            ),
                          ),
                        ),
                        title: Text(character.name),
                        subtitle: Text(character.summary),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => Navigator.pushNamed(
                            context, CharacterScreen.route,
                            arguments: PathId(
                                dictionaryId: _dictionaryId,
                                elementId: character.id)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

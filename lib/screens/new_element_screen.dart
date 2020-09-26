import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:novelsolutely/models/other.dart';

//LIBRARIES
import 'package:uuid/uuid.dart';

//MODELS
import '../models/character_name.dart';
import '../models/dictionary.dart';
import '../models/id_path.dart';
import '../models/generic.dart';
import '../models/item.dart' as IP;
import '../models/character.dart';

//WIDGETS
import '../screens/widgets/image_widget.dart';

//UTILS
import '../utils/data.dart';
import '../utils/dimens.dart';
import '../utils/routes.dart';
import '../utils/strings.dart';
import '../utils/colors.dart';

class NewElementScreen extends StatefulWidget {
  static const route = '/new';

  @override
  _NewElementScreenState createState() => _NewElementScreenState();
}

class _NewElementScreenState extends State<NewElementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _imageController = TextEditingController();
  final _summaryController = TextEditingController();

  List<String> _tags = [];
  final _tagStateKey = GlobalKey<TagsState>();

  List<bool> _selected;
  double _width;
  Dictionary _dictionary;
  IdPath _idPath;

  @override
  void initState() {
    _selected = new List<bool>.filled(Routes.navigation.length, false);
    _selected[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _idPath = ModalRoute.of(context).settings.arguments;
    _dictionary = Data.box.get(_idPath.idDictionary);

    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        title: Text('${Strings.newElement} ${_dictionary.name}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.vertical_margin,
          horizontal: Dimens.horizontal_margin,
        ),
        child: Container(
          width: _width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Strings.chose_category,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              _buttons(),
              Container(
                child: Divider(),
                margin: EdgeInsets.symmetric(
                    vertical: Dimens.small_vertical_margin),
              ),
              Text(
                Strings.data,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              _form(),
              Container(
                child: Divider(),
                margin: EdgeInsets.symmetric(
                    vertical: Dimens.small_vertical_margin),
              ),
              Text(
                Strings.tags,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              _tagList(),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveElement,
        label: Text(
          Strings.save.toUpperCase(),
        ),
      ),
    );
  }

  Widget _buttons() {
    var toggleSize = (_width - Dimens.horizontal_margin * 2 - 10) / 4;
    return ToggleButtons(
      children: [
        for (final item in Routes.navigation)
          Container(
            width: toggleSize,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [Icon(item.icon), Text(item.title)],
            ),
          )
      ],
      isSelected: _selected,
      onPressed: (index) {
        _selected = new List<bool>.filled(Routes.navigation.length, false);
        _selected[index] = true;
        setState(() {});
      },
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: Strings.name),
            validator: (value) {
              if (value.isEmpty && !_selected[0]) {
                return Strings.error_empty;
              }
              if (_selected[0] && _needName()) {
                return Strings.error_empty_name;
              }
              return null;
            },
          ),
          if (_selected[0])
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: Strings.nickname),
              validator: (value) {
                if (_needName()) {
                  return Strings.error_empty_name;
                }
                return null;
              },
            ),
          if (_selected[0])
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: Strings.surname),
              validator: (value) {
                if (_needName()) {
                  return Strings.error_empty_name;
                }
                return null;
              },
            ),
          if (_imageController.text != null && _imageController.text.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ImageWidget(url: _imageController.text),
            ),
          TextField(
            autofocus: false,
            decoration: InputDecoration(labelText: Strings.add_image),
            controller: _imageController,
            onChanged: (_) {
              setState(() {});
            },
          ),
          TextFormField(
            autofocus: false,
            decoration: InputDecoration(labelText: Strings.summary),
            controller: _summaryController,
            validator: (value) {
              if (value.isEmpty) {
                return Strings.error_empty;
              }
              return null;
            },
            maxLength: 250,
            onChanged: (_) {
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Widget _tagList() {
    return Tags(
        key: _tagStateKey,
        textField: TagsTextField(
          autofocus: false,
          hintText: Strings.add_tag,
          width: _width,
          onSubmitted: (String str) {
            setState(() {
              if (!Strings.containsCaseInsensitive(str, _tags)) _tags.add(str);
            });
          },
        ),
        itemCount: _tags.length,
        itemBuilder: (int index) {
          final item = _tags[index];
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
        });
  }

  bool _needName() =>
      '${_nameController.text}${_nicknameController.text}${_surnameController.text}'
          .trim()
          .isEmpty;

  void removeItem(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _saveElement() {
    if (_selected[0]) _saveCharacter();
    if (_selected[1]) _savePlace();
    if (_selected[2]) _saveItem();
    if (_selected[3]) _saveOther();
  }

  void _saveCharacter() {
    CharacterName name = CharacterName.fromInputs(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        nickname: _nicknameController.text.trim());

    Character character = _genGeneric().toCharacter();
    character.name = name.registerName();

    if (_dictionary.characters == null) _dictionary.characters = [];
    setState(() {
      _dictionary.characters.add(character);
    });
    _dictionary.save();
    Navigator.pop(context, true);
  }

  void _savePlace() {
    if (_dictionary.places == null) _dictionary.places = [];
    setState(() {
      _dictionary.places.add(_genGeneric().toPlaceOrItem());
    });
    _dictionary.save();
    Navigator.pop(context, true);
  }

  void _saveItem() {
    if (_dictionary.items == null) _dictionary.items = [];
    setState(() {
      _dictionary.items.add(_genGeneric().toPlaceOrItem());
    });
    _dictionary.save();
    Navigator.pop(context, true);
  }

  void _saveOther() {
    if (_dictionary.others == null) _dictionary.others = [];
    setState(() {
      _dictionary.others.add(_genGeneric().toOther());
    });
    _dictionary.save();
    Navigator.pop(context, true);
  }

  Generic _genGeneric() {
    return Generic(
      id: Uuid().v1(),
      name: _nameController.text.trim(),
      tags: _tags != null && _tags.length > 0 ? _tags : [Strings.no_filter],
      summary: _summaryController.text.trim(),
      imagePath: [_imageController.text.trim()],
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

//LIBRARIES
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

//MODELS
import '../models/generic.dart';
import '../models/item.dart';
import '../models/character_name.dart';
import '../models/dictionary.dart';

//UTILS
import '../utils/dimens.dart';
import '../utils/routes.dart';
import '../utils/strings.dart';
import '../utils/data.dart';

class ImportTextScreen extends StatefulWidget {
  static final route = '/import-text';

  @override
  _ImportTextScreenState createState() => _ImportTextScreenState();
}

class _ImportTextScreenState extends State<ImportTextScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<bool> _selected;
  double _width = 0;
  int _value = 0;
  File _file;
  int _total;
  String _id;

  final _startCharController = TextEditingController();
  final _endCharController = TextEditingController();
  final _paragraphController = TextEditingController();
  final _importController = TextEditingController();

  @override
  void initState() {
    _selected = new List<bool>.filled(Routes.navigation.length, false);
    _selected[0] = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _id = ModalRoute.of(context).settings.arguments;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Strings.import_from_text),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.vertical_margin,
            horizontal: Dimens.horizontal_margin,
          ),
          width: _width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _setSettings(),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton.icon(
                    onPressed: _searchFile,
                    label: Text(Strings.select_file.toUpperCase()),
                    icon: Icon(Icons.attach_file),
                  ),
                  RaisedButton.icon(
                    onPressed: _importElements,
                    icon: Icon(Icons.file_upload),
                    label: Text(Strings.save.toUpperCase()),
                  ),
                ],
              ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              Text(
                Strings.copy_text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              _file == null
                  ? TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 900,
                      controller: _importController,
                      onChanged: (value) {},
                    )
                  : ListTile(
                      leading: Icon(Icons.attachment),
                      title: Text(
                        _file.path.split('/')[_file.path.split('/').length - 1],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _file = null;
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                    ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setValueNameSummary(int value) {
    setState(() {
      _value = value;
    });
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

  Widget _setSettings() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        Strings.chose_settings,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
      children: [
        SizedBox(
          height: Dimens.small_vertical_margin,
        ),
        _buttons(),
        ListTile(
          onTap: () => _setValueNameSummary(0),
          leading: Radio(
            value: 0,
            onChanged: (int value) => _setValueNameSummary(value),
            groupValue: _value,
          ),
          title: Text('${Strings.paragraph_breakpoint}'),
          subtitle: Text('${Strings.name} y ${Strings.summary}'),
        ),
        ListTile(
          onTap: () => _setValueNameSummary(1),
          leading: Radio(
            value: 1,
            onChanged: (int value) => _setValueNameSummary(value),
            groupValue: _value,
          ),
          title: Text('${Strings.character_breakpoint}'),
          subtitle: Text(
              '${Strings.name}${_paragraphController.text}${Strings.summary}'),
          trailing: Container(
            width: 24.0,
            child: TextFormField(
              controller: _paragraphController,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                errorText:
                    _paragraphController.text.trim().isEmpty && _value == 1
                        ? ''
                        : null,
              ),
            ),
          ),
        ),
        if (_paragraphController.text.trim().isEmpty && _value == 1)
          _setError(),
        if (_selected[0])
          ListTile(
            leading: IconButton(
              icon: Icon(Routes.navigation[0].icon),
              onPressed: null,
            ),
            title: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('${Strings.surname}, ${Strings.name}'),
                Container(
                  width: 24.0,
                  child: TextFormField(
                    controller: _startCharController,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      errorText:
                          _startCharController.text.trim().isEmpty ? '' : null,
                    ),
                  ),
                ),
                Text(Strings.nickname),
                Container(
                  width: 24.0,
                  child: TextFormField(
                      controller: _endCharController,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        errorText:
                            _endCharController.text.trim().isEmpty ? '' : null,
                      )),
                ),
              ],
            ),
            subtitle: Text(Strings.check_format),
          ),
        if (_startCharController.text.trim().isEmpty ||
            _endCharController.text.trim().isEmpty)
          _setError(),
        SizedBox(
          height: Dimens.small_vertical_margin,
        ),
      ],
    );
  }

  Future<void> _saveToFile(String value) async {
    final file = await _localFile;
    // Write the file.
    file.writeAsString('$value');
    _readFileLineByLine(file);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void _readFileLineByLine(File file) {
    Stream<List<int>> inputStream = file.openRead();
    Dictionary dictionary = Data.box.get(_id);
    String name;
    int i = 0;
    _total = 0;
    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      // Process results.
      i++;

      if (_value == 0) {
        if (i % 2 == 0) {
          if (_selected[0]) {
            Generic generic = _genericIsCharacter(name, line);
            _saveCharacter(dictionary, generic);
          } else {
            Generic generic = _getGeneric(name, line);
            if (_selected[3])
              _saveOther(dictionary, generic);
            else
              _saveItemOrPlace(dictionary, generic);
          }
        } else {
          name = line.trim();
        }
      } else {
        // TODO
        _setByCharacter(line, dictionary);
      }
    }, onDone: () {
      dictionary.save();
      setState(() {
        _importController.text = '';
        _file = null;
      });
      _done();
    }, onError: (e) {
      print(e.toString());
    });
  }

  void _saveCharacter(Dictionary dictionary, Generic generic) {
    if (dictionary.characters == null) dictionary.characters = [];
    if (generic != null) {
      int index = _selected.indexWhere((element) => element);
      String type = Routes.navigation[index].title;
      if (!Data.elementExistsByName(_id, type, generic.name)) {
        dictionary.characters.add(generic.toCharacter());
        _total++;
      }
    }
  }

  void _saveItemOrPlace(Dictionary dictionary, Generic generic) {
    int index = _selected.indexWhere((element) => element);
    String type = Routes.navigation[index].title;
    if (dictionary.places == null) dictionary.places = [];
    if (dictionary.items == null) dictionary.items = [];
    if (generic != null) {
      Item item = generic.toPlaceOrItem();
      bool notFound = !Data.elementExistsByName(_id, type, generic.name);
      if (_selected[1]) {
        if (notFound) {
          dictionary.places.add(item);
          _total++;
        }
      } else {
        if (notFound) {
          dictionary.items.add(item);
          _total++;
        }
      }
    }
  }

  void _saveOther(Dictionary dictionary, Generic generic) {
    if (dictionary.others == null) dictionary.others = [];
    if (generic != null) {
      int index = _selected.indexWhere((element) => element);
      String type = Routes.navigation[index].title;
      if (!Data.elementExistsByName(_id, type, generic.name)) {
        dictionary.others.add(generic.toOther());
        _total++;
      }
    }
  }

  void _setByCharacter(String line, Dictionary dictionary) {
    List<String> text = line.split(_paragraphController.text.trim());
    Generic generic = _genericIsCharacter(text[0], text[1]);
    _saveCharacter(dictionary, generic);
  }

  Generic _genericIsCharacter(String completeName, String summary) {
    CharacterName characterName = CharacterName(completeName,
        startChar: _startCharController.text.trim() ?? '«',
        endChar: _endCharController.text.trim() ?? '»');

    return _getGeneric(characterName.registerName(), summary);
  }

  Generic _getGeneric(String name, String summary) {
    Generic generic = Generic(
        id: Uuid().v1(),
        name: '$name',
        summary: summary.trim(),
        imagePath: [],
        tags: [Strings.no_filter]);
    return generic;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  void _searchFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path);
      });
    }
  }

  void _importElements() {
    if (_startCharController.text.trim().isNotEmpty &&
        _endCharController.text.trim().isNotEmpty &&
        (_value == 0 || _paragraphController.text.trim().isNotEmpty)) {
      if (_file == null) {
        _saveToFile(_importController.text.trim());
      } else {
        _readFileLineByLine(_file);
      }
    }
  }

  Widget _setError() {
    return Text(Strings.error_empty,
        style: TextStyle(color: Theme.of(context).errorColor));
  }

  void _done() {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('${Strings.import_done} $_total.'),
      action: SnackBarAction(
        label: Strings.X,
        onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

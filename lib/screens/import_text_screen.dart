import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:novelsolutely/models/generic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

//UTILS
import '../utils/dimens.dart';
import '../utils/routes.dart';
import '../utils/strings.dart';

class ImportTextScreen extends StatefulWidget {
  static final route = '/import-text';

  @override
  _ImportTextScreenState createState() => _ImportTextScreenState();
}

class _ImportTextScreenState extends State<ImportTextScreen> {
  List<bool> _selected;
  double _width = 0;
  int _value = 0;

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
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.import_from_text),
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
              _setSettings(),
              Text(
                Strings.copy_text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: Dimens.small_vertical_margin,
              ),
              RaisedButton(
                onPressed: () => _saveToFile(_importController.text.trim()),
                child: Wrap(
                  children: [Icon(Icons.file_upload), Text(Strings.save)],
                ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 900,
                controller: _importController,
                onChanged: (value) {},
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
    return Column(
      children: [
        Text(
          Strings.chose_settings,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: Dimens.small_vertical_margin,
        ),
        _buttons(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  controller: _paragraphController..text = ':',
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
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
                        controller: _startCharController..text = '«',
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Text(Strings.nickname),
                    Container(
                      width: 24.0,
                      child: TextFormField(
                        controller: _endCharController..text = '»',
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                subtitle: Text(Strings.check_format),
              ),
          ],
        ),
        Container(
          child: Divider(),
          margin: EdgeInsets.symmetric(vertical: Dimens.small_vertical_margin),
        ),
      ],
    );
  }

  Future<void> _saveToFile(String value) async {
    final file = await _localFile;

    // Write the file.
    file.writeAsString('$value');
    _readLine(file);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  void _readLine(File file) {
    Stream<List<int>> inputStream = file.openRead();

    String name;
    int i = 0;
    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      // Process results.
      i++;
      if (i % 2 == 0) {
        Generic generic = Generic(
            id: Uuid().v1(),
            name: name,
            summary: line.trim(),
            imagePath: [],
            tags: [Strings.no_filter]);
        print(generic.name);
      } else {
        name = line.trim();
      }
    }, onDone: () {
      //TODO: save
    }, onError: (e) {
      print(e.toString());
    });
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }
}

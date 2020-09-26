import 'package:flutter/material.dart';

//MODELS
import '../../models/generic.dart';
import '../../models/character_name.dart';

//UTILS
import '../../utils/strings.dart';
import '../../utils/dimens.dart';

class GenericInputDialog extends StatefulWidget {
  final bool isCharacter;
  final Generic generic;

  GenericInputDialog(this.generic, {this.isCharacter = false});

  @override
  _GenericInputDialogState createState() =>
      _GenericInputDialogState(generic, isCharacter);
}

class _GenericInputDialogState extends State<GenericInputDialog> {
  final bool _isCharacter;
  Generic _generic;

  _GenericInputDialogState(this._generic, this._isCharacter) {
    if (_isCharacter) {
      CharacterName name = CharacterName(_generic.name);
      _nameController.text = name.name;
      _nicknameController.text =
          name.nickname.replaceAll('«', '').replaceAll('»', '');
      _surnameController.text = name.surname;
    } else {
      _nameController.text = _generic.name;
    }
    _summaryController.text = _generic.summary;
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          '${Strings.edit} a ${CharacterName.readableName(_generic.name)}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _form(),
            Container(
              child: Divider(),
              margin:
                  EdgeInsets.symmetric(vertical: Dimens.small_vertical_margin),
            ),
            SizedBox(
              height: Dimens.small_vertical_margin,
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Strings.cancel.toUpperCase())),
        FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _updateGeneric();
                Navigator.pop(context, _generic);
              }
            },
            child: Text(Strings.save.toUpperCase())),
      ],
    );
  }

  void _updateGeneric() {
    if (_isCharacter) {
      _generic.name = CharacterName.fromInputs(
              name: _nameController.text ?? '',
              nickname: _nicknameController.text ?? '',
              surname: _surnameController.text ?? '')
          .registerName();
    } else {
      _generic.name = _nameController.text;
    }
    _generic.summary = _summaryController.text ?? '';
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
              if (value.isEmpty && !_isCharacter) {
                return Strings.error_empty;
              }
              if (_isCharacter && _needName()) {
                return Strings.error_empty_name;
              }
              return null;
            },
          ),
          if (_isCharacter)
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
          if (_isCharacter)
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

  bool _needName() =>
      '${_nameController.text}${_nicknameController.text}${_surnameController.text}'
          .trim()
          .isEmpty;
}

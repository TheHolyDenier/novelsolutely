import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DialogNewProject extends StatefulWidget {
  @override
  _DialogNewProjectState createState() => _DialogNewProjectState();
}

class _DialogNewProjectState extends State<DialogNewProject> {
  final _form = GlobalKey<FormState>();
  final _controller = TextEditingController();
  var _autovalidate = false;

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          'nuevo proyecto',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Pacifico', color: Theme.of(context).primaryColor),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width > 500 ? 500 : 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AutoSizeText(
              'Rellene el siguiente campo, se utilizará para crear su proyecto:',
              maxLines: 2,
              softWrap: true,
            ),
            Form(
              key: _form,
              autovalidate: _autovalidate,
              child: TextFormField(
                controller: _controller,
                onChanged: (_) {
                  setState(() {});
                },
                maxLines: 4,
                minLines: 1,
                maxLength: 150,
                decoration: InputDecoration(
                  labelText: 'Título de tu proyecto',
                ),
                validator: (value) => value.isEmpty
                    ? 'Este campo no puede estar vacío'
                    : value.length < 2
                        ? 'Título demasiado corto'
                        : value.length > 151 ? 'Título demasiado largo' : null,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Cancelar',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            'Guardar',
          ),
          onPressed: () {
            if (_form.currentState.validate())
              Navigator.of(context).pop(_controller.text.trim());
            else
              setState(() {
                _autovalidate = true;
              });
          },
        ),
      ],
      shape: RoundedRectangleBorder(
          side: BorderSide(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}

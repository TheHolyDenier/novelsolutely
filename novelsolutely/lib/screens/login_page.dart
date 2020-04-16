import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/logged-user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _signIn = true;
  var _autoValidate = false;
  var _showPassword = true;
  final _inputMail = TextEditingController();
  final _inputName = TextEditingController();
  final _inputPwd = TextEditingController();

  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _inputMail.dispose();
    _inputPwd.dispose();
    _inputName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 60.0),
              child: Container(
                width: size > 500 ? 500 : double.infinity,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (size > 500)
                        SizedBox(
                          height: 25.0,
                        ),
                      if (size <= 500) _widgetTitle(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _signIn ? _loginWidget() : _registerWidget(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: _signIn ? _login : _register,
                          child: Text(_signIn ? 'Inicia sesión' : 'Regístrate'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (size > 500)
              Positioned(
                top: -30,
                right: 0,
                left: 0,
                child: _widgetTitle(),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _signIn = !_signIn;
                    });
                  },
                  child: Text(
                      _signIn
                          ? '¿Necesitas cuenta? ¡Regístrate!'
                          : '¿Ya tienes cuenta? ¡Inicia sesión!',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    Provider.of<AuthService>(context, listen: false)
        .loginUser(email: _inputMail.text, password: _inputPwd.text);
  }

  void _register() async {
    if (_formKeyRegister.currentState.validate()) {
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _inputMail.text, password: _inputPwd.text))
            .user;
        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = _inputName.text;
        user.updateProfile(userUpdateInfo).then((_) {
          _login();
        });
      } on AuthException catch (error) {
        print('${error.code}: ${error.message}');
      } on Exception catch (error) {
        print(error.toString());
      }
    } else {
      _autoValidate = true;
    }
  }

  Widget _registerWidget() {
    return Form(
      key: _formKeyRegister,
      autovalidate: _autoValidate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            validator: (name) {
              if (name.isEmpty) {
                return 'Este campo es obligatorio';
              } else if (name.length > 4) {
                return 'Escriba un nombre de al menos 4 caracteres.';
              }
              return null;
            },
            controller: _inputName,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          _widgetEmail(),
          _widgetPassword(),
        ],
      ),
    );
  }

  Widget _loginWidget() {
    return Form(
      key: _formKeyLogin,
      autovalidate: _autoValidate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _widgetEmail(),
          _widgetPassword(),
        ],
      ),
    );
  }

  Widget _widgetTitle() {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        'novelsolutely',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget _widgetEmail() {
    return TextFormField(
      validator: (email) {
        if (email.isEmpty) {
          return 'Este campo es obligatorio';
        } else if (!EmailValidator.validate(email)) {
          return 'Introduzca un e-mail válido';
        }
        return null;
      },
      controller: _inputMail,
      decoration: InputDecoration(
        labelText: 'E-mail',
      ),
    );
  }

  Widget _widgetPassword() {
    return Stack(
      children: <Widget>[
        TextFormField(
          validator: (password) {
            if (password.isEmpty) {
              return 'Este campo es obligatorio';
            } else if (password.length > 6) {
              return 'La contraseña debe de tener al menos 6 caracteres';
            }
            return null;
          },
          controller: _inputPwd,
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: _showPassword,
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon:
                Icon(!_showPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
      ],
    );
  }
}

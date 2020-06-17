import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
              email: _email, password: _password)) as FirebaseUser;
          print('Signed in: ${user.uid}');
        } else {
          FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: _email, password: _password)) as FirebaseUser;
          print('Registered in: ${user.uid}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sumiser'),
      ),
      body: new Container(
        padding: EdgeInsets.all(24.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButton(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButton() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),

          ),
          padding: EdgeInsets.all(8.0),
          child: new Text('Login', style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSave,
        ),
        new FlatButton(
          child: new Text(
            'Create an account', style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToRegister,
        )
      ];
    } else{
      return [
        new RaisedButton(
          child: new Text('Create an account', style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSave,
        ),
        new FlatButton(
          child: new Text(
            'Have an account? Login', style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
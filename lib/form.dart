import 'package:flutter/material.dart';
import 'package:flutter_one/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormWidget extends StatefulWidget {
  @override
  FormWidgetState createState() => FormWidgetState();
}

class FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "form",
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  EmailTextField(),
                  SizedBox(height: 24),
                  EmailTextField(),
                  SizedBox(height: 24),
                  Text(
                    "${AppLocalizations.of(context).hello} " * 2,
                    style: TextStyle(fontSize: 26),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailTextField extends StatefulWidget {
  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "labelText",
        border: OutlineInputBorder(),
        errorText: _errorText,
      ),
      onChanged: (text) {
        setState(() {
          _errorText = isEmail(text) ? null : "not a email!";
        });
      },
      onSubmitted: (text) async {
        int counter = await _saveEmail(text);
        var result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
                  content: Text(text),
                  title: Text("title $counter"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(text),
                      child: Text("ok"),
                    )
                  ],
                ));
        Scaffold.of(context).showSnackBar(new SnackBar(
          duration: Duration(seconds: 2),
          content: new Text("$result"),
        ));
      },
    );
  }

  Future<int> _saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    print('prev email =  ${prefs.getString("email")}');
    await prefs.setInt('counter', counter);
    await prefs.setString("email", email);
    return prefs.getInt("counter");
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    return regExp.hasMatch(em);
  }
}

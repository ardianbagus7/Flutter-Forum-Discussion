import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/widgets/notification_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final String status;
  Login({Key key, @required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextEditingController nrpController =
        TextEditingController(text: "ardianbagus7@gmail.com");
    final TextEditingController passwordController =
        TextEditingController(text: "ketupat");

    void submit() {
      Provider.of<AuthProvider>(context, listen: false)
          .signin(nrpController.text, passwordController.text);
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: nrpController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'NRP',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: (status != "Status.Authenticating")
                ? RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Login'),
                    onPressed: submit,
                  )
                : Center(
                  child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(),
                    ),
                ),
          ),
          Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ?? NotificationText(''),
          ),
        ],
      ),
    );
  }
}

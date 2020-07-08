import 'package:flutter/material.dart';


class Relogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: new CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

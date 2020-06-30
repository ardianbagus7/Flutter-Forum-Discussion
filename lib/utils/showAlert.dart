import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';

void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Peringatan',
          style: AppStyle.textRegular,
        ),
        content: Container(
          height: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 9 / 10,
                height: 30.0,
                child: Text(
                  'Gagal menyambungkan ke server',
                  style: AppStyle.textBody1,
                ),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
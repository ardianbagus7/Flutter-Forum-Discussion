import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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

void showVerifikasi(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Peringatan',
        style: AppStyle.textRegular,
      ),
      content: Container(
        height: 130.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 9 / 10,
              height: 70.0,
              child: Text(
                'Silahkan verifikasi akun anda untuk menggunakan fitur ini',
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

Future<String> showDelete(
    BuildContext context, int id, String token, int role) async {
  bool _status = false;
  String status;
  return status = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Peringatan',
        style: AppStyle.textRegular,
      ),
      content: Container(
        height: 90.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 9 / 10,
                child: Text(
                  'Thread akan dihapus secara permanen',
                  style: AppStyle.textBody1,
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 10.0)),
            Expanded(
              child: FlatButton(
                child: new Text("Ok"),
                onPressed: () async {
                  _status =
                      await Provider.of<PostProvider>(context, listen: false)
                          .deletePost(id, token, role);
                  if (_status) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context, 'ok');
                      Navigator.pop(context, 'ok');
                    });
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName('/'),
                      );
                      showAlert(context);
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
              ),
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

Future<String> showDeleteUser(
    BuildContext context, int id, String token) async {
  bool _status;
  String status;
  return status = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Peringatan',
        style: AppStyle.textRegular,
      ),
      content: Container(
        height: 90.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 9 / 10,
                child: Text(
                  'Akun akan dihapus secara permanen',
                  style: AppStyle.textBody1,
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 10.0)),
            Expanded(
              child: FlatButton(
                child: new Text("Ok"),
                onPressed: () async {
                  _status =
                      await Provider.of<AdminProvider>(context, listen: false)
                          .getDeleteUser(token, id);

                  Navigator.pop(context, 'ok');
                  if (_status) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context, 'ok');
                    });
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      showAlert(context);
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
              ),
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

void showDeleteKomentar(
    BuildContext context, int idPost, int id, String token, int role) {
  bool _status = false;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Peringatan',
        style: AppStyle.textRegular,
      ),
      content: Container(
        height: 110.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 9 / 10,
                child: Text(
                  'Komentar akan dihapus secara permanen',
                  style: AppStyle.textBody1,
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 10.0)),
            Expanded(
              child: FlatButton(
                child: new Text("Ok"),
                onPressed: () async {
                  _status =
                      await Provider.of<PostProvider>(context, listen: false)
                          .deleteKomentar(id, token, role);
                  if (_status) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pop();
                      showAlert(context);
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
              ),
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

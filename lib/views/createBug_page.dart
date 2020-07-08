import 'dart:io';

import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class CreateBug extends StatefulWidget {
  final String token;
  CreateBug({Key key, @required this.token}) : super(key: key);
  @override
  _CreateBugState createState() => _CreateBugState(token: token);
}

class _CreateBugState extends State<CreateBug> {
  final String token;
  _CreateBugState({Key key, @required this.token});

  int statusKategori;
  List kategori = [
    'Forum Alumni',
    'Kompetisi',
    'Mata Kuliah',
    'Beasiswa',
    'Keluh kesah'
  ];
  var statusCreate;
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    statusCreate = Provider.of<AdminProvider>(context).statusCreateBug;

    void submit() async {
      bool status = await Provider.of<AdminProvider>(context, listen: false)
          .createBug(descriptionController.text, _image, token);
      if (status) {
        Navigator.pop(context, 'ok');
      } else {
        setState(() {
          statusCreate = 'menunggu';
          showAlert(context);
        });
      }
    }

    return Scaffold(
      appBar: appBar(submit),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: AppStyle.decorationCard,
                      margin: EdgeInsets.only(top: 100),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 80.0),
                            deskripsiField(),
                            SizedBox(height: 20.0),
                            //submitPost(submit),
                          ],
                        ),
                      ),
                    ),
                    Center(child: imagePost()),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Container submitPost(void submit()) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: (statusCreate == 'loading')
          ? Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: new CircularProgressIndicator(),
              ),
            )
          : RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Kirim'),
              onPressed: () {
                submit();
              },
            ),
    );
  }

  Column deskripsiField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text('Deskripsi', style: AppStyle.textSubHeadingAbu),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            controller: descriptionController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppStyle.colorBg,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none),
            ),
            maxLines: 15,
          ),
        ),
      ],
    );
  }

  InkWell imagePost() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            elevation: 10.0,
            context: context,
            backgroundColor: AppStyle.colorBg,
            builder: (builder) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    height: 50.0,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Pilih Foto',
                        style: AppStyle.textHeadlineTipisBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            getImage(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: AppStyle.colorMain,
                                size: 50,
                              ),
                              Text(
                                'Kamera',
                                style: AppStyle.textCaption2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.photo_library,
                                  color: AppStyle.colorMain,
                                  size: 50,
                                ),
                                Text(
                                  'Galeri',
                                  style: AppStyle.textCaption2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            });
        // getImage(ImageSource.camera);
      },
      child: Container(
        color: Colors.grey,
        height: 180.0,
        width: 180.0,
        child: (_image == null)
            ? Icon(Icons.add_a_photo, color: Colors.white, size: 40.0)
            : FittedBox(fit: BoxFit.cover, child: Image.file(_image)),
      ),
    );
  }

  AppBar appBar(void submit()) {
    return AppBar(
      backgroundColor: AppStyle.colorBg,
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: AppStyle.colorMain,
          size: 35,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('Mulai Diskusi', style: AppStyle.textSubHeadlineBlack),
      actions: <Widget>[
        Center(
          child: InkWell(
            onTap: () {
              submit();
            },
            child: (statusCreate == 'loading')
                ? Center(
                    child: SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: new CircularProgressIndicator(),
                    ),
                  )
                : Text('Kirim', style: AppStyle.textSubHeadlineBlack),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}

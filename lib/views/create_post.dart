import 'dart:io';

import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/ClipPathHome.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  int statusKategori;
  List kategori = ['Forum Alumni', 'Kompetisi', 'Mata Kuliah', 'Beasiswa','Keluh kesah'];
  var statusCreate;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    statusCreate = Provider.of<PostProvider>(context).statusCreate;

    void submit() async {
      bool status = await Provider.of<PostProvider>(context, listen: false)
          .createPost(titleController.text, descriptionController.text,
              kategori[statusKategori], _image);
      if (status) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home-page', (Route<dynamic> route) => false);
      } else {
        setState(() {
          statusCreate = 'menunggu';
          showAlert(context);
        });
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: CustomClipPathHome(),
              child: Container(
                height: 220.0,
                width: double.infinity,
                color: AppStyle.colorMain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                decoration: AppStyle.decorationCard,
                transform: Matrix4.translationValues(0.0, -110.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      imagePost(),
                      SizedBox(height: 20.0),
                      judulField(),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Kategori', style: AppStyle.textSubHeadingAbu),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 30.0,
                              width:
                                  MediaQuery.of(context).size.width * 14 / 16,
                              child: ListView.builder(
                                itemCount: kategori.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, i) {
                                  return FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          statusKategori = i;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 2.0),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: (i == statusKategori)
                                            ? BoxDecoration(
                                                color: AppStyle.colorMain,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                              )
                                            : BoxDecoration(
                                                color: AppStyle.colorWhite,
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                              ),
                                        child: Text(
                                          '${kategori[i]}',
                                          style: (statusKategori == i)
                                              ? AppStyle.textSubHeadingPutih
                                              : AppStyle.textSubHeadingAbu,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      deskripsiField(),
                      SizedBox(height: 20.0),
                      Container(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container deskripsiField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        keyboardType: TextInputType.multiline,
        controller: descriptionController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Deskripsi',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
        ),
        maxLines: 10,
      ),
    );
  }

  Container judulField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: titleController,
        maxLength: 50,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Judul',
        ),
      ),
    );
  }

  InkWell imagePost() {
    return InkWell(
      onTap: () {
        getImage();
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

  AppBar appBar() {
    return AppBar(
      backgroundColor: AppStyle.colorMain,
      bottomOpacity: 0,
      elevation: 0,
      title: Text(
        'Mulai Diskusi',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      actions: <Widget>[
        Center(
          child: Text(
            'Kirim',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}

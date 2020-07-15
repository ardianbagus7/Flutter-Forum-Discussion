import 'dart:io';

import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/animation/fade.dart';
import 'package:discussion_app/utils/dropDownAngkatan.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:image_picker/image_picker.dart';

class EditProfil extends StatefulWidget {
  final String image;
  final String name;
  final String angkatan;
  final String token;
  final String nomer;
  EditProfil({Key key, @required this.image, this.name, this.angkatan, this.token, this.nomer}) : super(key: key);
  @override
  _EditProfilState createState() => _EditProfilState(image: image, name: name, angkatan: angkatan, token: token, nomer: nomer);
}

class _EditProfilState extends State<EditProfil> {
  final String image;
  final String name;
  String angkatan;
  final String token;
  String nomer;
  _EditProfilState({Key key, @required this.image, this.name, this.angkatan, this.token, this.nomer});

  var statusCreate;
  File _image;
  final picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nomerController = TextEditingController();
  @override
  void initState() {
    nomer = nomer.substring(2, nomer.length);
    titleController = TextEditingController(text: name);
    descriptionController = TextEditingController(text: angkatan);
    nomerController = TextEditingController(text: nomer);
    super.initState();
  }

  Future getImage(ImageSource imageSource) async {
    //ImageSource.gallery

    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    statusCreate = Provider.of<PostProvider>(context).statusEditProfil;

    void submit() async {
      bool status = await Provider.of<PostProvider>(context, listen: false).editProfil(titleController.text, angkatan, _image, '62${nomerController.text}', token);
      if (status) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Provider.of<AuthProvider>(context, listen: false).updateData(titleController.text, descriptionController.text);
          Navigator.of(context).pop('ok');
        });
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
                    PopUp(
                      0.5,
                      Container(
                        decoration: AppStyle.decorationCard,
                        margin: EdgeInsets.only(top: 80),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 80.0),
                              SizedBox(height: 20.0),
                              PopUp(1.5, judulField()),
                              PopUp(2.0, deskripsiField()),
                              PopUp(2.5, nomerField()),
                              SizedBox(height: 20.0),
                              //submitPost(submit),
                            ],
                          ),
                        ),
                      ),
                    ),
                    PopUp(1.0, Center(child: imagePost())),
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

  Column nomerField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text('Nomer Telepon', style: AppStyle.textSubHeadingAbu),
        ),
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: nomerController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 55, top: 20, bottom: 20, right: 20),
                  isDense: true,
                  filled: true,
                  fillColor: AppStyle.colorBg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 26),
              child: Text('+62', style: AppStyle.textSubHeadingAbu),
            )
          ],
        ),
      ],
    );
  }

  Column deskripsiField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text('Angkatan', style: AppStyle.textSubHeadingAbu),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: InkWell(
            child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppStyle.colorBg,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ), //
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (angkatan == null)
                              ? Text(
                                  'Pilih tahun angkatan..',
                                  style: AppStyle.textCaption2grey,
                                )
                              : Text(
                                  angkatan,
                                  style: AppStyle.textCaption2,
                                ),
                          Icon(Icons.keyboard_arrow_down, color: AppStyle.colorMain)
                        ],
                      )),
                )),
            onTap: () async {
              String _angkatan = await Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) => DropDownAngkatan(),
                ),
              );
              setState(() {
                angkatan = _angkatan;
              });
            },
          ),
        ),
      ],
    );
  }

  Column judulField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text('Nama', style: AppStyle.textSubHeadingAbu),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: titleController,
            maxLength: 50,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppStyle.colorBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
            ),
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
            isScrollControlled: true,
            builder: (builder) {
              return SingleChildScrollView(
                child: Column(
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
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            });
        // getImage(ImageSource.camera);
      },
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: 180.0,
            width: 180.0,
            child: (_image == null)
                ? CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => CircleAvatar(radius: 70, backgroundColor: Colors.grey[200], child: Center(child: Icon(Icons.image, color: Colors.grey))),
                    errorWidget: (context, url, error) => CircleAvatar(radius: 70, backgroundColor: Colors.grey[200], child: Center(child: Text('${name[0]}', style: AppStyle.textSubHeadlineBlack))),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 70,
                    ),
                  )
                : CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(_image),
                  ),
          ),
          Positioned(bottom: 10, right: 10, child: CircleAvatar(radius: 20, backgroundColor: AppStyle.colorMain, child: Icon(Icons.edit, color: Colors.white, size: 25)))
        ],
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
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Edit Profil', style: AppStyle.textSubHeadlineBlack),
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

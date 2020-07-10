import 'dart:async';
import 'dart:io';

import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class EditPost extends StatefulWidget {
  final String token;
  final int postId;
  final idPost;
  final title;
  final deskripsi;
  EditPost(
      {Key key,
      @required this.token,
      this.postId,
      this.idPost,
      this.title,
      this.deskripsi})
      : super(key: key);
  @override
  _EditPostState createState() => _EditPostState(
      token: token,
      postId: postId,
      idPost: idPost,
      title: title,
      deskripsi: deskripsi);
}

class _EditPostState extends State<EditPost> {
  final String token;
  final int postId;
  final idPost;
  String title;
  String deskripsi;
  _EditPostState(
      {Key key,
      @required this.token,
      this.postId,
      this.idPost,
      this.title,
      this.deskripsi});
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
  var detailPost;

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIdPost();
    });
  }

  void getIdPost() async {
    bool _status = await Provider.of<PostProvider>(context, listen: false)
        .getIdPost(postId, token);
    if (_status) {
      int index = kategori.indexWhere((element) => element == idPost.kategori);
      statusKategori = index;
      titleController = TextEditingController(text: title);
      descriptionController = TextEditingController(text: deskripsi);
    }
  }

  void didChangeDepedencies() {
    print('didChangeDepedencies');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    statusCreate = Provider.of<PostProvider>(context).statusEditPost;
    detailPost = Provider.of<PostProvider>(context).idPost ?? null;

    void submit() async {
      bool status = await Provider.of<PostProvider>(context, listen: false)
          .editPost(postId, titleController.text, descriptionController.text,
              kategori[statusKategori], _image, token);
      if (status) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Provider.of<PostProvider>(context, listen: false)
              .getIdPost(detailPost.post[0].id, token);
          Navigator.pop(context, 'ok');
          Navigator.pop(context, 'ok');
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
          child: (detailPost == null)
              ? Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
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
                                  kategoriField(context),
                                  SizedBox(height: 20.0),
                                  judulField(),
                                  deskripsiField(),
                                  SizedBox(height: 20.0),
                                  //submitPost(submit),
                                ],
                              ),
                            ),
                          ),
                          Center(child: imagePost(detailPost)),
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

  Padding kategoriField(BuildContext context) {
    return Padding(
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
            width: MediaQuery.of(context).size.width * 14 / 16,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                                  color: Colors.black.withOpacity(0.5)),
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
            maxLines: 10,
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
          child: Text('Judul', style: AppStyle.textSubHeadingAbu),
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
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }

  InkWell imagePost(detailPost) {
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
            ? FittedBox(
                fit: BoxFit.cover,
                child: CachedNetworkImage(
                  imageUrl: detailPost.post[0].postImage,
                ),
              )
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
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Edit Thread', style: AppStyle.textSubHeadlineBlack),
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

import 'dart:async';

import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/services/role.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/utils/timeAgoIndo.dart';
import 'package:discussion_app/views/profile_page.dart';
import 'package:discussion_app/views/reLogin_view.dart';
import 'package:discussion_app/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class KomentarAuthCheck extends StatelessWidget {
  final detailPost;
  final String token;
  final String name;
  final int role;
  final int idUser;
  KomentarAuthCheck({Key key, @required this.detailPost, this.token, this.name, this.role, this.idUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, user, child) {
      if (user.status == Status.Relogin || user.status == Status.Authenticating || user.status == Status.Unauthenticated) {
        return Relogin();
      } else {
        return KomentarScreen(
          token: user.token,
          name: name,
          role: role,
          idUser: idUser,
          detailPost: detailPost,
        );
      }
    });
  }
}

class KomentarScreen extends StatefulWidget {
  final detailPost;
  final String token;
  final String name;
  final int role;
  final int idUser;
  KomentarScreen({Key key, @required this.detailPost, this.token, this.name, this.role, this.idUser}) : super(key: key);
  @override
  _KomentarScreenState createState() => _KomentarScreenState(detailPost: detailPost, token: token, idUser: idUser, role: role);
}

class _KomentarScreenState extends State<KomentarScreen> {
  var statusKomentar;
  final String token;
  final int idUser;
  TextEditingController komentarController = TextEditingController();
  final detailPost;

  final String name;
  final int role;
  _KomentarScreenState({Key key, @required this.detailPost, this.token, this.role, this.name, this.idUser});
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var detailPostNew = Provider.of<PostProvider>(context).idPost ?? null;
    statusKomentar = Provider.of<PostProvider>(context).statusKomentar;

    void submit(String id) async {
      bool status1 = await Provider.of<PostProvider>(context, listen: false).createKomentar(id, komentarController.text, token);
      bool status2 = await Provider.of<PostProvider>(context, listen: false).getIdPost(detailPost.post[0].id, token);
      if (status1 && status2) {
        komentarController = TextEditingController(text: '');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        });
      } else {
        setState(() {
          statusKomentar = 'menunggu';
          showAlert(context);
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppStyle.colorBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: (detailPostNew == null)
                      ? PlaceHolderKomentar()
                      : ListView.builder(
                          controller: _controller,
                          itemCount: detailPostNew.komentar.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 20,
                                    foregroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(detailPostNew.komentar[index].image),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE2E2E2),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          margin: EdgeInsets.only(left: 10.0),
                                          width: MediaQuery.of(context).size.width * 13 / 16,
                                          child: Material(
                                            color: Colors.white.withOpacity(0.0),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(10),
                                              radius: 500,
                                              splashColor: AppStyle.colorMain,
                                              highlightColor: Colors.grey.withOpacity(0.5),
                                              onLongPress: () {
                                                print('long pres $index');
                                                longTapKomen(context, detailPostNew, index);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${detailPostNew.komentar[index].name}',
                                                      style: AppStyle.textName,
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                      '${detailPostNew.komentar[index].komentar}',
                                                      style: AppStyle.textSubHeadlineBlack,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:18.0),
                                        child: Text(
                                          timeAgoIndo(detailPostNew.komentar[index].createdAt),
                                          style: AppStyle.textCaption,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  width: double.infinity,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0.0, -0.5),
                        blurRadius: 15.0,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: (role == Role.alumni && detailPost.post[0].kategori != 'Forum Alumni' && detailPost.post[0].kategori != 'Info Prodi')
                        ? Center(child: Text('Tidak bisa komentar di kategori ini', style: AppStyle.textCaption))
                        : Row(
                            children: <Widget>[
                              Expanded(
                                flex: 8,
                                child: Container(
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    controller: komentarController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: 'Komentar..',
                                    ),
                                  ),
                                ),
                              ),
                              (statusKomentar != 'loading')
                                  ? IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        if (role == 0) {
                                          showVerifikasi(context);
                                        } else {
                                          submit('${detailPost.post[0].id}');
                                        }
                                      },
                                    )
                                  : Center(
                                      child: SizedBox(
                                        height: 30.0,
                                        width: 30.0,
                                        child: new CircularProgressIndicator(),
                                      ),
                                    )
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future longTapKomen(BuildContext context, detailPostNew, int index) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      elevation: 10.0,
      context: context,
      backgroundColor: AppStyle.colorBg,
      builder: (builder) {
        return (detailPostNew.komentar[index].userId == idUser || role == Role.developer || role == Role.admin)
            ? Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    title: Text(
                      'Lihat profil',
                      style: AppStyle.textSubHeadingAbu,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilPage(
                                    id: detailPostNew.komentar[index].userId,
                                    token: token,
                                  )));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                    ),
                    title: Text(
                      'Hapus Komentar',
                      style: AppStyle.textSubHeadingAbu,
                    ),
                    onTap: () {
                      //detailPostNew.komentar[index].
                      showDeleteKomentar(context, detailPost.post[0].id, detailPostNew.komentar[index].id, token, role);
                    },
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    title: Text(
                      'Lihat profil',
                      style: AppStyle.textSubHeadingAbu,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilPage(
                                    id: detailPostNew.komentar[index].userId,
                                    token: token,
                                  )));
                    },
                  ),
                ],
              );
      },
    );
  }
}

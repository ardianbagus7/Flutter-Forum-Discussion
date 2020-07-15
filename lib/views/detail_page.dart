import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/services/role.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/utils/timeAgoIndo.dart';
import 'package:discussion_app/views/editPost_page.dart';
import 'package:discussion_app/views/komentar_page.dart';
import 'package:discussion_app/views/profile_page.dart';
import 'package:discussion_app/views/reLogin_view.dart';
import 'package:discussion_app/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class DetailPostAuthCheck extends StatelessWidget {
  final int id;
  final int index;
  final String image;
  final String token;
  final String name;
  final int role;
  final int idUser;
  DetailPostAuthCheck({Key key, @required this.id, this.image, this.index, this.token, this.name, this.role, this.idUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, user, child) {
      if (user.status == Status.Relogin || user.status == Status.Authenticating || user.status == Status.Unauthenticated) {
        return Relogin();
      } else {
        return DetailPage(
          token: user.token,
          image: image,
          index: index,
          name: name,
          role: role,
          id: id,
          idUser: idUser,
        );
      }
    });
  }
}

class DetailPage extends StatefulWidget {
  final int id;
  final int index;
  final String image;
  final String token;
  final String name;
  final int role;
  final int idUser;
  DetailPage({Key key, @required this.id, this.image, this.index, this.token, this.name, this.role, this.idUser}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState(index: index, id: id, image: image, token: token, name: name, role: role, idUser: idUser);
}

class _DetailPageState extends State<DetailPage> {
  final int id;
  final int index;
  final String image;
  final String token;
  final String name;
  final int role;
  final int idUser;
  _DetailPageState({Key key, @required this.index, this.id, this.image, this.token, this.name, this.role, this.idUser});

  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PostProvider>(context, listen: false).getIdPost(id, token);
    });
  }

  @override
  Widget build(BuildContext context) {
    var detailPost = Provider.of<PostProvider>(context).idPost ?? null;
    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: AppStyle.colorMain,
                    size: 35,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: <Widget>[
                (detailPost == null)
                    ? SizedBox()
                    : (detailPost.post[0].userId == idUser || role == Role.developer || role == Role.admin)
                        ? InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
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
                                        SizedBox(height: 10.0),
                                        ListTile(
                                            leading: Icon(
                                              Icons.edit,
                                            ),
                                            title: Text(
                                              'Edit thread',
                                              style: AppStyle.textSubHeadingAbu,
                                            ),
                                            onTap: () async {
                                              String _status = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditPost(
                                                    token: token,
                                                    postId: id,
                                                    idPost: detailPost.post[0],
                                                    title: detailPost.post[0].title,
                                                    deskripsi: detailPost.post[0].description,
                                                  ),
                                                ),
                                              );
                                              setState(() {
                                                print(_status);
                                                if (_status == 'ok') {
                                                  Provider.of<PostProvider>(context, listen: false).getIdPost(detailPost.post[0].id, token);
                                                  _status = "";
                                                }
                                              });
                                            }),
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
                                            'Hapus thread',
                                            style: AppStyle.textSubHeadingAbu,
                                          ),
                                          onTap: () async {
                                            String _status = await showDelete(context, detailPost.post[0].id, token, role);
                                            if (_status == 'ok') {
                                              Navigator.pop(context, 'ok');
                                            }
                                          },
                                        ),
                                        SizedBox(height: 10.0),
                                      ],
                                    ),
                                  );
                                },
                              );
                              /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPost(
                            token: token, idPost: detailPost, postId: id),
                      ),
                    ); */
                            },
                            child: Icon(
                              Icons.menu,
                              color: AppStyle.colorMain,
                              size: 35,
                            ),
                          )
                        : SizedBox(),
                SizedBox(width: 20)
              ],
              stretch: true,
              title: Text('Diskusi', style: TextStyle(color: AppStyle.colorMain)),
              backgroundColor: Colors.white,
              expandedHeight: MediaQuery.of(context).size.height / 3,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                background: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) => FullScreen(
                          index: id,
                          image: image,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'fullscreen$id',
                    child: Container(
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new CachedNetworkImageProvider(image),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        }, //detailPost.post[0].title
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: (detailPost == null)
                ? PlaceHolderDetailPost()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilPage(
                                            id: detailPost.post[0].userId,
                                            token: token,
                                          )));
                            },
                            child: CachedNetworkImage(
                              imageUrl: detailPost.post[0].userImage,
                              placeholder: (context, url) => CircleAvatar(radius: 30, backgroundColor: Colors.grey[200], child: Center(child: Icon(Icons.image,color: Colors.grey))),
                              errorWidget: (context, url, error) => CircleAvatar(radius: 30, backgroundColor: Colors.grey[200], child: Center(child: Text('${name[0]}', style: AppStyle.textSubHeadlineBlack))),
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 7 / 10,
                                    child: Text(
                                      '${detailPost.post[0].name}',
                                      style: AppStyle.textName,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      detailPost.post[0].kategori,
                                      style: AppStyle.textCaption,
                                    ),
                                    SizedBox(width: 5),
                                    CircleAvatar(radius: 2, backgroundColor: Color(0xFF646464)),
                                    SizedBox(width: 5),
                                    Text(
                                      timeAgoIndo(detailPost.post[0].createdAt),
                                      style: AppStyle.textCaption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        '${detailPost.post[0].title}',
                        style: AppStyle.textHeadlineBlack,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${detailPost.post[0].description}',
                        style: AppStyle.textSubHeadlineBlack,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 30),
                      Divider(
                        thickness: 2,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) => KomentarAuthCheck(
                                detailPost: detailPost,
                                token: token,
                                name: name,
                                role: role,
                                idUser: idUser,
                              ),
                            ),
                          );
                          //komentarSheet(context, detailPost);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.mode_comment, color: Colors.grey, size: 25),
                            SizedBox(width: 10),
                            Text('Komentar', style: AppStyle.textCaption),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  final int index;
  final String image;
  FullScreen({Key key, @required this.index, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.85),
        body: Center(
          child: Hero(
            tag: 'fullscreen$index',
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
        ),
      ),
    );
  }
}

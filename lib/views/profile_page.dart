import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/animation/fade.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:discussion_app/services/role.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilPage extends StatefulWidget {
  final int id;
  final String token;
  ProfilPage({Key key, this.id, this.token}) : super(key: key);
  @override
  _ProfilPageState createState() => _ProfilPageState(id: id, token: token);
}

class _ProfilPageState extends State<ProfilPage> with TickerProviderStateMixin {
  final int id;
  final String token;
  _ProfilPageState({Key key, this.id, this.token});

  //*
  var detailProfil;
  String name;
  int role;
  int idUser;
  //*
  ScrollController scrollControl;
  double scrollOffset;
  bool statusScroll = false;
  bool isLoading = false;
  var allPost;
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _iconColorTween, _opacityTween;
  Animation<Offset> _transTween;
  String tokenProvider;
  int status = 0;
  TextEditingController searchController = TextEditingController();

  //* URL LAUNCHER
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('tidak bisa terhubung $command');
    }
  }

  @override
  void initState() {
    _colorAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 0));

    _iconColorTween = ColorTween(begin: Colors.grey, end: AppStyle.colorMain).animate(_colorAnimationController);
    _opacityTween = Tween<double>(begin: 0, end: 1).animate(_colorAnimationController);
    _textAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(0, 40), end: Offset(0, 0)).animate(_textAnimationController);

    print('tes $detailProfil');
    Future.microtask(() {
      // Provider.of<PostProvider>(context, listen: false).getAllPosts();
      Provider.of<PostProvider>(context, listen: false).getDetailProfilId(id, token);
    });
    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 125);
      _textAnimationController.animateTo((scrollInfo.metrics.pixels - 125) / 50);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    detailProfil = Provider.of<PostProvider>(context).detailProfilId ?? null;
    name = Provider.of<AuthProvider>(context).name ?? null;
    role = Provider.of<AuthProvider>(context).role ?? null;
    idUser = Provider.of<AuthProvider>(context).idUser;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: (detailProfil == null)
            ? Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                height: double.infinity,
                child: Stack(
                  children: <Widget>[
                    SafeArea(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: PopUp(
                                    0.5,
                                    Container(
                                      margin: EdgeInsets.only(top: 100),
                                      height: 310,
                                      decoration: BoxDecoration(
                                        color: AppStyle.colorWhite,
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            offset: Offset(0.0, 2),
                                            blurRadius: 15.0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    PopUp(
                                      1.0,
                                      Center(
                                        child: CircleAvatar(
                                          radius: 75,
                                          backgroundColor: AppStyle.colorMain3,
                                          child: CachedNetworkImage(
                                            imageUrl: detailProfil.user.image,
                                            placeholder: (context, url) => CircleAvatar(radius: 70, backgroundColor: Colors.grey[200], child: Center(child: Icon(Icons.image, color: Colors.grey))),
                                            errorWidget: (context, url, error) => CircleAvatar(radius: 70, backgroundColor: Colors.grey[200], child: Center(child: Text('${detailProfil.user.name[0]}', style: AppStyle.textSubHeadlineBlack))),
                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                              backgroundImage: imageProvider,
                                              radius: 70,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    PopUp(
                                      1.5,
                                      Center(
                                        child: Text(
                                          '${detailProfil.user.name}',
                                          style: AppStyle.textHeadlineProfil,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    PopUp(
                                      2,
                                      Center(
                                        child: roleView(context, detailProfil.user.role),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    (detailProfil.user.role == 0)
                                        ? SizedBox()
                                        : PopUp(
                                            2.5,
                                            Center(
                                              child: Text(
                                                'Angkatan ${detailProfil.user.angkatan}',
                                                style: AppStyle.textSubHeadlineBlack,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 5),
                                    (detailProfil.user.role == 0)
                                        ? SizedBox()
                                        : PopUp(
                                            3,
                                            Center(
                                              child: Text(
                                                '${detailProfil.user.nrp}',
                                                style: AppStyle.textSubHeadlineBlack,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                      child: PopUp(
                                        3.5,
                                        Divider(
                                          thickness: 2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    PopUp(
                                      3.5,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              print(detailProfil.user.email);
                                              customLaunch('mailto:${detailProfil.user.email}');
                                            },
                                            child: Icon(MdiIcons.gmail, color: AppStyle.colorMain, size: 50),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              customLaunch('whatsapp://send?phone=${detailProfil.user.nomer}');
                                            },
                                            child: Icon(MdiIcons.whatsapp, color: AppStyle.colorMain, size: 50),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: PopUp(
                                4,
                                Divider(
                                  thickness: 2,
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: PopUp(4, Text('Thread terbaru', style: AppStyle.textList)),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                              return FadeInUp(
                                4 + 0.5 + index,
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPostAuthCheck(
                                          id: detailProfil.post[index].id,
                                          image: detailProfil.post[index].postImage,
                                          index: index,
                                          token: token,
                                          name: name,
                                          role: role,
                                          idUser: idUser,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.0),
                                      width: double.infinity,
                                      height: 100.0,
                                      child: Row(
                                        children: <Widget>[
                                          Hero(
                                            tag: 'fullscreen${detailProfil.post[index].id}',
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: new CachedNetworkImageProvider(detailProfil.post[index].postImage),
                                                ),
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '${detailProfil.post[index].name}',
                                                    style: AppStyle.textBody1,
                                                  ),
                                                  Container(
                                                    height: 50.0,
                                                    width: MediaQuery.of(context).size.width * 6 / 10,
                                                    child: Text(
                                                      '${detailProfil.post[index].title}',
                                                      style: AppStyle.textRegular,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${detailProfil.post[index].kategori}',
                                                    style: AppStyle.textCaption,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: detailProfil.post.length),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 100)),
                        ],
                      ),
                    ),
                    Container(
                      height: 83,
                      child: AnimatedBuilder(
                        animation: _colorAnimationController,
                        builder: (context, child) => Opacity(
                          opacity: _opacityTween.value,
                          child: AppBar(
                            backgroundColor: AppStyle.colorBg,
                            centerTitle: true,
                            title: Transform.translate(
                              offset: _transTween.value,
                              child: Text(
                                '${detailProfil.user.name}',
                                style: AppStyle.textSubHeadlineBlack,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            iconTheme: IconThemeData(
                              color: _iconColorTween.value,
                            ),
                            actions: <Widget>[
                              /* Transform.translate(
                              offset: _transTween.value,
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                ),
                                onPressed: () {},
                              ),
                            ), */
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

import 'package:discussion_app/models/AllPosts_model.dart';
import 'package:discussion_app/models/notif_model.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/services/role.dart';
import 'package:discussion_app/utils/ClipPathHome.dart';
import 'package:discussion_app/utils/ClipShadowPath.dart';
import 'package:discussion_app/utils/animation/fade.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/utils/timeAgoIndo.dart';
import 'package:discussion_app/views/adminPanel_page.dart';
import 'package:discussion_app/views/createBug_page.dart';
import 'package:discussion_app/views/createForm_page.dart';
import 'package:discussion_app/views/create_post.dart';
import 'package:discussion_app/views/detail_page.dart';
import 'package:discussion_app/views/editPost_page.dart';
import 'package:discussion_app/views/profile_page.dart';
import 'package:discussion_app/views/search_page.dart';
import 'package:discussion_app/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:discussion_app/views/editProfil_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //* PAGE VIEW
  int bottomNavBarIndex;
  PageController pageController;

  //*PAGINATE ALL POSTS
  List<Datum> allPosts;
  bool isLoadingMore;
  List<DatumNotif> allNotif;

  int totalNotif;

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

  //* SIDE BAR
  bool sidebaropen = false;
  double yOffset = 0;
  double xOffset = 0;
  double pageScale = 1;

  //* SIDE BAR NOTIF
  bool sidebarnotifopen = false;
  double xOffsetNotif = 0;

  //* VERIFIKASI
  bool loadingVerifikasi = false;
  String statusVerifikasi;
  String pinVerifikasi;
  TextEditingController nrpController = TextEditingController();
  int statusRole = 1;
  List listRole = [
    'Guest',
    'Mahasiswa Aktif',
    'Fungsionaris',
    'Alumni',
    'Dosen',
  ];
  bool loadingGetVerifikasi = false;
  String statusGetVerifikasi;
  String roleName;
  int nomer;

  //*FEEDBACK
  TextEditingController feedbackController = TextEditingController();
  String statusFeedback;
  bool loadingFeedback = false;

  void setSidebarState() {
    setState(() {
      xOffset = sidebaropen ? MediaQuery.of(context).size.width * 13 / 18 : 0;
      yOffset = sidebaropen ? MediaQuery.of(context).size.width * 4 / 16 : 0;
      pageScale = sidebaropen ? 0.8 : 1;
    });
  }

  void setSidebarNotifState() {
    setState(() {
      xOffset = sidebarnotifopen ? -MediaQuery.of(context).size.width : 0;
      xOffsetNotif = sidebarnotifopen ? 0 : MediaQuery.of(context).size.width;
    });
  }

  //* KONTAK DEVELOPER
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('tidak bisa terhubung $command');
    }
  }

  @override
  void initState() {
    super.initState();

    _colorAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 0));

    _iconColorTween = ColorTween(begin: Colors.grey, end: AppStyle.colorMain).animate(_colorAnimationController);
    _opacityTween = Tween<double>(begin: 0, end: 1).animate(_colorAnimationController);
    _textAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(0, 40), end: Offset(0, 0)).animate(_textAnimationController);

    Future.microtask(() {
      xOffsetNotif = MediaQuery.of(context).size.width;
      Provider.of<PostProvider>(context, listen: false).getAllNotif();
      Provider.of<PostProvider>(context, listen: false).getAllPosts();
      Provider.of<PostProvider>(context, listen: false).getDetailProfil();
    });

    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
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

  void submit() {
    Provider.of<AuthProvider>(context, listen: false).logOut(false);
    Provider.of<PostProvider>(context, listen: false).getLogout();
  }

  void filterPost(String kategori) {
    Provider.of<PostProvider>(context, listen: false).getFilterPost(kategori);
  }

  void getdata() {
    Provider.of<PostProvider>(context, listen: false).getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    List kategori = ['Semua', 'Info Prodi', 'Forum Alumni', 'Kompetisi', 'Mata Kuliah', 'Beasiswa', 'Keluh kesah'];
    String name = Provider.of<AuthProvider>(context).name;
    nomer = Provider.of<AuthProvider>(context).nomer;
    List nameSplit = name.split(' ');
    String profil = Provider.of<AuthProvider>(context).profil;
    var filterPost = Provider.of<PostProvider>(context).filterPosts ?? null;
    var detailProfil = Provider.of<PostProvider>(context).detailProfil ?? null;
    tokenProvider = Provider.of<AuthProvider>(context).token;
    int role = Provider.of<AuthProvider>(context).role;
    int idUser = Provider.of<AuthProvider>(context).idUser;
    isLoading = Provider.of<PostProvider>(context).isLoading ?? null;
    roleName = Provider.of<AuthProvider>(context).roleName;
    //* ALL POSTS
    allPosts = Provider.of<PostProvider>(context).allPosts ?? null;
    isLoadingMore = Provider.of<PostProvider>(context).isLoadingMore ?? false;
    //* FEEDBACK
    statusFeedback = Provider.of<PostProvider>(context).statusFeedback ?? 'menunggu';
    //* NOTIF
    allNotif = Provider.of<PostProvider>(context).allNotif ?? null;
    totalNotif = Provider.of<PostProvider>(context).totalNotif ?? null;

    return Scaffold(
      backgroundColor: AppStyle.colorBg,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: AppStyle.colorMain,
          child: Stack(
            children: <Widget>[
              //* SIDE BAR
              sideBar(role, context, profil, name, detailProfil),
              //* SIDE BAR NOTIF
              (!sidebaropen) ? sideBarNotif(context, name, role, idUser) : SizedBox(),
              //*HOME PAGE
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
                transform: Matrix4.translationValues(xOffset, yOffset, 1.0)..scale(pageScale),
                decoration: BoxDecoration(
                  color: AppStyle.colorBg,
                  borderRadius: sidebaropen ? BorderRadius.circular(20) : BorderRadius.circular(0),
                ),
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      bottomNavBarIndex = index;

                      if (index == 0) {
                        Provider.of<PostProvider>(context, listen: false).getAllPosts();
                      }
                      if (index == 1) {
                        Provider.of<PostProvider>(context, listen: false).getDetailProfil();
                      }
                    });
                  },
                  children: <Widget>[
                    // HALAMAN HOME PAGE / MAIN PAGE
                    GestureDetector(
                      onHorizontalDragUpdate: _handleDragUpdateFalse,
                      child: mainPage(name, nameSplit[0], profil, kategori, allPost, filterPost, role, idUser),
                    ),

                    //HALAMAN PROFIL
                    profilPage(detailProfil, name, profil, role, idUser)
                  ],
                ),
              ),
              customNavBar(),
              createPostButton(context, role)
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector sideBarNotif(BuildContext context, String name, int role, int idUser) {
    return GestureDetector(
      //allNotif[index].pesan
      onHorizontalDragUpdate: _handleDragUpdateTrueNotif,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),
        transform: Matrix4.translationValues(xOffsetNotif, 0, 1.0),
        color: AppStyle.colorBg,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoadingMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                // start loading data
                setState(() {
                  isLoadingMore = true;
                });
                //load data
                Provider.of<PostProvider>(context, listen: false).getAllNotifMore();
              }
              return true;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                bool _status = await Provider.of<PostProvider>(context, listen: false).getAllNotif();
                return _status;
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 50.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: AppStyle.colorBg,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 10, end: 0, top: 0),
                      title: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  sidebarnotifopen = false;
                                  setSidebarNotifState();
                                },
                                child: Icon(Icons.arrow_back_ios, color: AppStyle.colorMain),
                              ),
                              Text('Notifikasi', style: AppStyle.textHeadlineProfil),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 5)),
                  (allNotif == null)
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ) //
                      : SliverList(
                          //allNotif[index].pesan
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                color: (allNotif[index].read == 0) ? Colors.grey.withOpacity(0.2) : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProfilPage(
                                                id: allNotif[index].userPesanId,
                                                token: tokenProvider,
                                              ),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: CachedNetworkImageProvider(allNotif[index].image),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            Provider.of<PostProvider>(context, listen: false).getReadNotif(allNotif[index].id);
                                            String _status = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetailPostAuthCheck(
                                                  id: allNotif[index].postId,
                                                  image: allNotif[index].imagePost,
                                                  index: index,
                                                  token: tokenProvider,
                                                  name: name,
                                                  role: role,
                                                  idUser: idUser,
                                                ),
                                              ),
                                            );
                                            if (_status == null) {
                                              Provider.of<PostProvider>(context, listen: false).getAllNotif();
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(bottom: 2),
                                                child: Text('${allNotif[index].pesan}', style: AppStyle.textBody1Black, maxLines: 2, overflow: TextOverflow.ellipsis),
                                              ),
                                              Text('${timeAgoIndo(allNotif[index].createdAt)}', style: AppStyle.textCaption),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      InkWell(
                                        onTap: () async {
                                          Provider.of<PostProvider>(context, listen: false).getReadNotif(allNotif[index].id);
                                          String _status = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPostAuthCheck(
                                                id: allNotif[index].postId,
                                                image: allNotif[index].imagePost,
                                                index: index,
                                                token: tokenProvider,
                                                name: name,
                                                role: role,
                                                idUser: idUser,
                                              ),
                                            ),
                                          );
                                          if (_status == null) {
                                            Provider.of<PostProvider>(context, listen: false).getAllNotif();
                                          }
                                        },
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new CachedNetworkImageProvider(allNotif[index].imagePost),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: allNotif.length,
                          ),
                        ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: isLoadingMore ? 50.0 : 0,
                      color: Colors.transparent,
                      child: Center(
                        child: new CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 100))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdateTrueNotif(DragUpdateDetails details) {
    print(details.primaryDelta);
    if (details.primaryDelta < -10) {
      sidebarnotifopen = true;
      setSidebarNotifState();
    }
    if (details.primaryDelta > 10) {
      sidebarnotifopen = false;
      setSidebarNotifState();
    }
  }

  void _handleDragUpdateTrue(DragUpdateDetails details) {
    print(details.primaryDelta);
    if (details.primaryDelta < -10) {
      sidebaropen = false;
      setSidebarState();
    }
    if (details.primaryDelta > 10) {
      sidebaropen = true;
      setSidebarState();
    }
  }

  void _handleDragUpdateFalse(DragUpdateDetails details) {
    print(details.primaryDelta);
    if (details.primaryDelta > 10) {
      sidebaropen = true;
      setSidebarState();
    }
    if (details.primaryDelta < -10 && sidebaropen == false) {
      sidebarnotifopen = true;
      setSidebarNotifState();
    }
  }

  sideBar(int role, BuildContext context, String profil, String name, detailProfil) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdateTrue,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    sidebaropen = !sidebaropen;
                    setSidebarState();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: yOffset,
                    //child: Text('Aplikasi diskusi'),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                        (role == Role.developer || role == Role.admin)
                            ? InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(MdiIcons.accountStar, color: Colors.white),
                                      SizedBox(width: 10),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 8 / 18,
                                        child: AutoSizeText('Admin panel', style: AppStyle.textSubHeadingPutih),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminAuthCheck()),
                                  );
                                },
                              )
                            : SizedBox(),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Icon(MdiIcons.accountSettings, color: Colors.white),
                                SizedBox(width: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width * 8 / 16,
                                  child: AutoSizeText('Pengaturan Akun', style: AppStyle.textSubHeadingPutih),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            String _status = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfil(
                                  image: profil,
                                  name: name,
                                  angkatan: detailProfil.user.angkatan,
                                  token: tokenProvider,
                                  nomer: '$nomer',
                                ),
                              ),
                            );

                            if (_status == "ok") {
                              Provider.of<AuthProvider>(context, listen: false).reLogin();
                              setState(() {
                                sidebaropen = false;
                                setSidebarState();
                              });
                            }
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Icon(MdiIcons.accountTieVoice, color: Colors.white),
                                SizedBox(width: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width * 8 / 16,
                                  child: AutoSizeText('Kontak Developer', style: AppStyle.textSubHeadingPutih),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              elevation: 10.0,
                              context: context,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              MdiIcons.gmail,
                                              color: AppStyle.colorMain,
                                              size: 50,
                                            ),
                                            onPressed: () {
                                              customLaunch('mailto:ardianbagus7@gmail.com');
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              MdiIcons.linkedin,
                                              color: AppStyle.colorMain,
                                              size: 50,
                                            ),
                                            onPressed: () {
                                              customLaunch('https://www.linkedin.com/in/ardianbagus/');
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              MdiIcons.instagram,
                                              color: AppStyle.colorMain,
                                              size: 50,
                                            ),
                                            onPressed: () {
                                              customLaunch('https://www.instagram.com/ardianbagus_/');
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Icon(MdiIcons.thumbsUpDown, color: Colors.white),
                                SizedBox(width: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width * 8 / 16,
                                  child: AutoSizeText('Saran dan Masukan', style: AppStyle.textSubHeadingPutih),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            sidebaropen = false;
                            feedbackController = TextEditingController(text: '');
                            setSidebarState();
                            //* FEEDBACK
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              elevation: 10.0,
                              context: context,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setModalState) {
                                    return Container(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                        },
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 20),
                                              Text(
                                                'Saran dan Masukan',
                                                style: AppStyle.textSubHeadingAbu,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                                child: TextField(
                                                  keyboardType: TextInputType.text,
                                                  controller: feedbackController,
                                                  maxLines: 10,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: AppStyle.colorBg,
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 13 / 16,
                                                      child: Text('Saran dan masukan anda sangat berguna untuk perkembangan aplikasi ini', style: AppStyle.textCaption),
                                                    ),
                                                    (loadingFeedback)
                                                        ? Center(child: CircularProgressIndicator())
                                                        : InkWell(
                                                            onTap: () async {
                                                              setModalState(() {
                                                                loadingFeedback = true;
                                                              });
                                                              bool _status = await Provider.of<PostProvider>(context, listen: false).createFeedback(feedbackController.text, tokenProvider);
                                                              if (_status) {
                                                                loadingFeedback = false;
                                                                Navigator.of(context).pop();
                                                              } else {
                                                                setModalState(() {
                                                                  loadingFeedback = false;
                                                                  showAlert(context);
                                                                });
                                                              }
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor: AppStyle.colorMain,
                                                              radius: 20,
                                                              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Icon(MdiIcons.bugCheck, color: Colors.white),
                                SizedBox(width: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width * 8 / 16,
                                  child: AutoSizeText('Laporkan Bug', style: AppStyle.textSubHeadingPutih),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateBug(
                                  token: tokenProvider,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.logout, color: Colors.white),
                  title: Text('Logout', style: AppStyle.textSubHeadingPutih),
                  onTap: () {
                    submit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NotificationListener profilPage(detailProfil, String name, String profil, role, idUser) {
    return NotificationListener<ScrollNotification>(
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
                                child: Container(
                                  margin: EdgeInsets.only(top: 100),
                                  height: (role == 0) ? 300 : 240,
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
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 75,
                                      backgroundColor: AppStyle.colorMain3,
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage: CachedNetworkImageProvider(profil),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      '$name',
                                      style: AppStyle.textHeadlineProfil,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Center(
                                    child: roleView(context, role),
                                  ),
                                  SizedBox(height: 5),
                                  (role == 0)
                                      ? SizedBox()
                                      : Center(
                                          child: Text(
                                            'Angkatan ${detailProfil.user.angkatan}',
                                            style: AppStyle.textSubHeadlineBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  SizedBox(height: 5),
                                  (role == 0)
                                      ? SizedBox()
                                      : Center(
                                          child: Text(
                                            '${detailProfil.user.nrp}',
                                            style: AppStyle.textSubHeadlineBlack,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  SizedBox(height: 10),
                                  (role == 0)
                                      ? Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 34.0),
                                              child: InkWell(
                                                onTap: () {
                                                  //* VERIFIKASI
                                                  verifikasiAkun();
                                                  setState(() {
                                                    statusVerifikasi = '';
                                                    pinVerifikasi = '';
                                                    statusGetVerifikasi = '';
                                                    nrpController = TextEditingController(text: '');
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: AppStyle.colorMain,
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Verifikasi akun',
                                                    style: AppStyle.textSubHeading2Putih,
                                                  )),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 34.0),
                                              child: InkWell(
                                                onTap: () {
                                                  //* FORM VERIFIKASI
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CreateForm(
                                                        token: tokenProvider,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: AppStyle.colorMain,
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Request Invitation Key',
                                                    style: AppStyle.textSubHeading2Putih,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text('Thread terbaru', style: AppStyle.textList),
                          ),
                        ),
                        listAllPost(detailProfil.post, name, role, idUser),
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
                              '$name',
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
    );
  }

  Future verifikasiAkun() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      elevation: 10.0,
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState /*You can rename this!*/) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      (statusVerifikasi == 'true')
                          ? Text(
                              'Verifikasi NRP',
                              style: AppStyle.textSubHeadingAbu,
                            )
                          : Text(
                              'Invitation Key',
                              style: AppStyle.textSubHeadingAbu,
                            ),
                      SizedBox(height: 20),
                      (statusVerifikasi == 'true')
                          ? SizedBox()
                          : (loadingVerifikasi)
                              ? Center(child: CircularProgressIndicator())
                              : OTPTextField(
                                  length: 6,
                                  width: MediaQuery.of(context).size.width,
                                  fieldWidth: 40,
                                  style: TextStyle(fontSize: 17),
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                  onCompleted: (pin) async {
                                    print("Completed: " + pin);
                                    setModalState(() {
                                      loadingVerifikasi = true;
                                    });
                                    String _status = await Provider.of<PostProvider>(context, listen: false).getCekVerifikasi(pin);

                                    setModalState(() {
                                      if (_status == 'true') {
                                        print('valid');
                                        pinVerifikasi = pin;
                                        statusVerifikasi = 'true';
                                        loadingVerifikasi = false;
                                      } else if (_status == 'false') {
                                        print('tidak valid');
                                        pinVerifikasi = pin;
                                        statusVerifikasi = 'false';
                                        loadingVerifikasi = false;
                                      } else if (_status == 'gagal') {
                                        print('gagal load');
                                        pinVerifikasi = pin;
                                        statusVerifikasi = 'gagal';
                                        loadingVerifikasi = false;
                                      }
                                      print(statusVerifikasi);
                                      print(pinVerifikasi);
                                    });
                                  },
                                ),
                      SizedBox(height: 10),
                      (statusVerifikasi == 'true')
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: Text('NRP', style: AppStyle.textSubHeadingAbu),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: nrpController,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppStyle.colorBg,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 13),
                                  child: Container(
                                    height: 30.0,
                                    child: ListView.builder(
                                      itemCount: listRole.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (_, i) {
                                        return (i == 0)
                                            ? SizedBox()
                                            : FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: InkWell(
                                                  onTap: () {
                                                    setModalState(() {
                                                      statusRole = i;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                    decoration: (i == statusRole)
                                                        ? BoxDecoration(
                                                            color: AppStyle.colorMain,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(50.0),
                                                            ),
                                                          )
                                                        : BoxDecoration(
                                                            color: AppStyle.colorWhite,
                                                            border: Border.all(color: Colors.black.withOpacity(0.5)),
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(50.0),
                                                            ),
                                                          ),
                                                    child: Text(
                                                      '${listRole[i]}',
                                                      style: (statusRole == i) ? AppStyle.textSubHeadingPutih : AppStyle.textSubHeadingAbu,
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Pastikan data anda benar dan sesuai', style: AppStyle.textCaption),
                                      (loadingGetVerifikasi)
                                          ? Center(child: CircularProgressIndicator())
                                          : InkWell(
                                              onTap: () async {
                                                setModalState(() {
                                                  loadingGetVerifikasi = true;
                                                });
                                                String _status = await Provider.of<PostProvider>(context, listen: false).getVerifikasi(pinVerifikasi, statusRole, nrpController.text, tokenProvider);
                                                if (_status == 'true') {
                                                  statusGetVerifikasi = 'true';
                                                  loadingGetVerifikasi = false;
                                                  Navigator.pop(context);
                                                  Provider.of<AuthProvider>(context, listen: false).reLogin();
                                                } else if (_status == 'nrp') {
                                                  setModalState(() {
                                                    loadingGetVerifikasi = false;
                                                    statusGetVerifikasi = 'nrp';
                                                  });
                                                } else {
                                                  setModalState(() {
                                                    loadingGetVerifikasi = false;
                                                    statusGetVerifikasi = 'false';
                                                  });
                                                }
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: AppStyle.colorMain,
                                                radius: 20,
                                                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                (statusGetVerifikasi == 'false') ? Text('Gagal upload data, server down') : (statusGetVerifikasi == 'nrp') ? Text('NRP sudah terdaftar') : SizedBox(),
                              ],
                            )
                          : (statusVerifikasi == 'false') ? Container(child: Text('tidak valid')) : (statusVerifikasi == 'gagal') ? Container(child: Text('Gagal load')) : SizedBox(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Align createPostButton(BuildContext context, int role) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),
        transform: Matrix4.translationValues(xOffset, yOffset, 1.0)..scale(pageScale),
        height: 66,
        width: 66,
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          backgroundColor: AppStyle.colorMain3,
          child: SizedBox(
            height: 36,
            width: 36,
            child: Icon(
              Icons.add,
              size: 36,
            ),
          ),
          onPressed: () async {
            if (role == 0) {
              showVerifikasi(context);
            } else {
              String _create = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePost(
                    token: tokenProvider,
                    role: role,
                  ),
                ),
              );
              if (!mounted) return;
              print(_create);
              setState(() {
                if (_create == 'ok') {
                  getdata();
                  _create = "";
                }
              });
            }
          },
        ),
      ),
    );
  }

  Align customNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),
        transform: Matrix4.translationValues(xOffset, yOffset, 1.0)..scale(pageScale),
        child: ClipShadowPath(
          shadow: Shadow(
            blurRadius: 15,
            offset: Offset(0, -2),
            color: Colors.black.withOpacity(0.25),
          ),
          clipper: CustomClipPathNavbar(),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppStyle.colorWhite,
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppStyle.colorMain,
              unselectedItemColor: Color(0xFFE5E5E5),
              currentIndex: bottomNavBarIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  bottomNavBarIndex = index;

                  pageController.jumpToPage(index);
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  title: Text(''),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  title: Text(''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SafeArea mainPage(String name, String nameSplit, String profil, List kategori, allPost, filterPost, int role, idUser) {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // start loading data
            setState(() {
              isLoadingMore = true;
            });
            //load data
            if (status == 0) {
              Provider.of<PostProvider>(context, listen: false).getAllPostMore();
            } else if (status != 0) {
              Provider.of<PostProvider>(context, listen: false).getAllFilterPostMore(kategori[status]);
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            bool _status = await Provider.of<PostProvider>(context, listen: false).getAllPosts();
            return _status;
          },
          child: CustomScrollView(
            controller: scrollControl,
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                backgroundColor: AppStyle.colorBg,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 10, end: 0, top: 0),
                  title: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: InkWell(
                        onTap: null,
                        child: Container(
                          height: 38.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              TextField(
                                controller: searchController,
                                style: AppStyle.textSearchPutih,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Cari diskusi...',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                ),
                                textInputAction: TextInputAction.search,
                                onSubmitted: (newValue) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (BuildContext context, _, __) => SearchPage(search: newValue, idUser: idUser, role: role, name: name, token: tokenProvider),
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      searchController = TextEditingController(text: '');
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.cancel, color: Colors.grey.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  collapseMode: CollapseMode.parallax,
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                //ganti state sidebar
                                sidebaropen = !sidebaropen;
                                setSidebarState();
                              },
                              child: Icon(Icons.menu, size: 30, color: AppStyle.colorMain),
                            ),
                            GestureDetector(
                              onTap: () {
                                //ganti notif sidebar
                                sidebarnotifopen = !sidebarnotifopen;
                                setSidebarNotifState();

                                Provider.of<PostProvider>(context, listen: false).getAllNotif();
                              },
                              child: Stack(
                                children: <Widget>[
                                  Icon(Icons.notifications, size: 30, color: AppStyle.colorMain),
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppStyle.colorMain3,
                                    child: AutoSizeText('$totalNotif', style: AppStyle.textNotif),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Hai,',
                                  style: AppStyle.textHeadlineTipisBlack,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 13 / 16 - 36,
                                  height: 30,
                                  child: Text(
                                    '$name',
                                    style: AppStyle.textHeadlineBlack,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            /*Hero(
                              tag: 'profil',
                              child: CircleAvatar(
                                radius: 23,
                                backgroundImage: CachedNetworkImageProvider(profil),
                              ),
                            ), */
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 20.0),
                  child: Text('Kategori', style: AppStyle.textList),
                ),
              ),
              SliverStickyHeader(
                header: kategoriListView(kategori),
                sliver: (status == 0) ? listAllPost(allPosts, name, role, idUser) : listAllPost(filterPost, name, role, idUser),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: isLoadingMore ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 150)),
            ],
          ),
        ),
      ),
    );
  }

  Widget listAllPost(allPost, name, role, idUser) {
    return (allPost == null)
        ? SliverToBoxAdapter(
            child: PlaceHolder(),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Material(
                  color: Colors.white.withOpacity(0.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    radius: 500,
                    splashColor: AppStyle.colorMain,
                    highlightColor: Colors.grey.withOpacity(0.5),
                    onLongPress: () {
                      print('long pres $index');
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
                        builder: (builder) {
                          return (allPost[index].userId == idUser || role == Role.developer || role == Role.admin)
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
                                                      id: allPost[index].userId,
                                                      token: tokenProvider,
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
                                        'Hapus thread',
                                        style: AppStyle.textSubHeadingAbu,
                                      ),
                                      onTap: () async {
                                        String _status = await showDelete(context, allPost[index].id, tokenProvider, role);
                                        setState(() {
                                          print(_status);
                                          if (_status == 'ok') {
                                            getdata();
                                            _status = "";
                                          }
                                        });
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilPage(id: allPost[index].userId)));
                                      },
                                    ),
                                  ],
                                );
                        },
                      );
                    },
                    onTap: () async {
                      String _status = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPostAuthCheck(
                            id: allPost[index].id,
                            image: allPost[index].postImage,
                            index: index,
                            token: tokenProvider,
                            name: name,
                            role: role,
                            idUser: idUser,
                          ),
                        ),
                      );
                      setState(() {
                        print(_status);
                        if (_status == 'ok') {
                          getdata();
                          _status = "";
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      width: double.infinity,
                      height: 100.0,
                      child: Row(
                        children: <Widget>[
                          Hero(
                            tag: 'fullscreen${allPost[index].id}',
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new CachedNetworkImageProvider(allPost[index].postImage),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${allPost[index].name}',
                                  style: AppStyle.textBody1,
                                ),
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 6 / 10,
                                    child: AutoSizeText(
                                      '${allPost[index].title}',
                                      style: AppStyle.textRegular,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${allPost[index].kategori}',
                                      style: AppStyle.textCaption,
                                    ),
                                    SizedBox(width: 5),
                                    CircleAvatar(radius: 2, backgroundColor: Color(0xFF646464)),
                                    SizedBox(width: 5),
                                    Text(
                                      '${timeAgoIndo(allPost[index].createdAt)}',
                                      style: AppStyle.textCaption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: allPost.length),
          );
  }

  Padding kategoriListView(List kategori) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20, left: 13),
      child: Container(
        height: 30.0,
        child: ListView.builder(
          itemCount: kategori.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) {
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: InkWell(
                onTap: () {
                  setState(() {
                    filterPost(kategori[i]);
                    status = i;

                    if (status == 0) {
                      getdata();
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: (i == status)
                      ? BoxDecoration(
                          color: AppStyle.colorMain,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        )
                      : BoxDecoration(
                          color: AppStyle.colorWhite,
                          border: Border.all(color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                  child: Text(
                    '${kategori[i]}',
                    style: (status == i) ? AppStyle.textSubHeadingPutih : AppStyle.textSubHeadingAbu,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

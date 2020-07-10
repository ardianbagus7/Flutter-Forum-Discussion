import 'package:discussion_app/models/allUser_model.dart';
import 'package:discussion_app/models/bug_model.dart';
import 'package:discussion_app/models/feedback_model.dart';
import 'package:discussion_app/models/formVerif_model.dart';
import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/reLogin_view.dart';
import 'package:discussion_app/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:discussion_app/models/filterUser_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminAuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, user, child) {
      if (user.status == Status.Relogin ||
          user.status == Status.Authenticating ||
          user.status == Status.Unauthenticated) {
        return Relogin();
      } else {
        return AdminPanel(token: user.token);
      }
    });
  }
}

class AdminPanel extends StatefulWidget {
  final String token;
  AdminPanel({Key key, @required this.token}) : super(key: key);
  @override
  _AdminPanelState createState() => _AdminPanelState(token: token);
}

class _AdminPanelState extends State<AdminPanel> {
  String token;
  _AdminPanelState({Key key, @required this.token});

  //*Page View
  int bottomNavBarIndex;
  PageController pageController;
  // bottomNavBarIndex = 0;
  // pageController = PageController(initialPage: bottomNavBarIndex);
  //*
  TextEditingController searchController = TextEditingController();

  //* VARIABLE
  var allKey;
  List<Datum> allUser;
  var isLoading;
  bool isLoadingMore;
  List<DatumFeedback> allFeedback;
  List<DatumFilterUser> allFilterUser;
  List<DatumBug> allBug;
  List<DatumForm> allForm;

  //* role
  List fixRole = [
    'Guest',
    'Mahasiswa Aktif',
    'Fungsionaris',
    'Alumni',
    'Dosen',
    'Admin',
    'Developer'
  ];
  List kategoriRole = [
    'Semua',
    'Guest',
    'Mahasiswa Aktif',
    'Fungsionaris',
    'Alumni',
    'Dosen',
    'Admin',
    'Developer'
  ];
  int statusRole = 0;
  bool isEditRole = false;
  bool loadingEditRole = false;
  int status = 0;

  //* BLOKIR DEFAULT IMAGE BUG
  String urlImageBug = 'http://192.168.43.47/bug/default.jpg';

  //* GET ALL USER DATA
  void getAllUser() {
    Provider.of<AdminProvider>(context, listen: false).getAllUser(token);
  }

  //* GET FILTER ROLE USER
  void getAllFilterUser({@required int role}) {
    Provider.of<AdminProvider>(context, listen: false)
        .getAllFilterUser(role, token);
  }

  //* CALL
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('tidak bisa terhubung $command');
    }
  }

  //*
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AdminProvider>(context, listen: false).getAllUser(token);
    });

    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
  }

  @override
  Widget build(BuildContext context) {
    allKey = Provider.of<AdminProvider>(context).allKey ?? null;
    allUser = Provider.of<AdminProvider>(context).allUser ?? null;
    allFilterUser = Provider.of<AdminProvider>(context).allFilterUser ?? null;
    isLoading = Provider.of<AdminProvider>(context).isLoading ?? false;
    isLoadingMore = Provider.of<AdminProvider>(context).isLoadingMore ?? false;
    allFeedback = Provider.of<AdminProvider>(context).allFeedback ?? null;
    allBug = Provider.of<AdminProvider>(context).allBug ?? null;
    allForm = Provider.of<AdminProvider>(context).allForm ?? null;

    return Scaffold(
      backgroundColor: AppStyle.colorBg,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    bottomNavBarIndex = index;

                    if (index == 0) {
                      Provider.of<AdminProvider>(context, listen: false)
                          .getAllUser(token);
                    }
                    if (index == 1) {
                      Provider.of<AdminProvider>(context, listen: false)
                          .getAllBug(token);
                    }
                    if (index == 2) {
                      Provider.of<AdminProvider>(context, listen: false)
                          .getAllFeedback(token);
                    }
                    if (index == 3) {
                      Provider.of<AdminProvider>(context, listen: false)
                          .getAllForm(token);
                    }
                    if (index == 4) {
                      Provider.of<AdminProvider>(context, listen: false)
                          .getAllKey(token);
                    }
                  });
                },
                children: <Widget>[
                  //* page user
                  pageUser(context),
                  //* page bug
                  pageBug(context),
                  //* page feedback
                  pageFeedback(context),
                  //* page form
                  pageForm(context),
                  //* page key
                  pageKey(context),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
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
                          MdiIcons.account,
                          size: 30,
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.bug_report,
                          size: 30,
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          MdiIcons.thumbsUpDown,
                          size: 30,
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          MdiIcons.formDropdown,
                          size: 30,
                        ),
                        title: Text(''),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.vpn_key,
                          size: 30,
                        ),
                        title: Text(''),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SafeArea pageBug(BuildContext context) {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // start loading data
            setState(() {
              isLoadingMore = true;
            });
            //load data
            Provider.of<AdminProvider>(context, listen: false)
                .getAllBugMore(token);
          }
          return true;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 65.0,
              floating: false,
              pinned: true,
              backgroundColor: AppStyle.colorBg,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsetsDirectional.only(
                    start: 0, bottom: 10, end: 0, top: 0),
                title: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text('Daftar Laporan Bug',
                        style: AppStyle.textHeadlineTipisBlack),
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            (allBug == null)
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
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: AppStyle.colorWhite,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0.0, 1),
                                        blurRadius: 15.0,
                                      )
                                    ],
                                  ), //'${allFeedback[index].deskripsi}'
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      allBug[index].userImage),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      11 /
                                                      16,
                                                  child: Text(
                                                    '${allBug[index].name}',
                                                    style: AppStyle.textName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                    '${allBug[index].createdAt.day}-${allBug[index].createdAt.month}-${allBug[index].createdAt.year} ${allBug[index].createdAt.hour}:${allBug[index].createdAt.minute}:${allBug[index].createdAt.second}',
                                                    style:
                                                        AppStyle.textCaption),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text('${allBug[index].deskripsi}',
                                            style:
                                                AppStyle.textSubHeadlineBlack),
                                        SizedBox(height: 10),
                                        (allBug[index].bugImage == urlImageBug)
                                            ? SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      opaque: false,
                                                      pageBuilder:
                                                          (BuildContext context,
                                                                  _, __) =>
                                                              FullScreen(
                                                        index: index,
                                                        image: allBug[index]
                                                            .bugImage,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Hero(
                                                  tag: 'fullscreenBug$index',
                                                  child: Container(
                                                    height: 300,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            new CachedNetworkImageProvider(
                                                                allBug[index]
                                                                    .bugImage),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      },
                      childCount: allBug.length,
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
    );
  }

  SafeArea pageFeedback(BuildContext context) {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // start loading data
            setState(() {
              isLoadingMore = true;
            });
            //load data
            Provider.of<AdminProvider>(context, listen: false)
                .getAllFeedbackMore(token);
          }
          return true;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 65.0,
              floating: false,
              pinned: true,
              backgroundColor: AppStyle.colorBg,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsetsDirectional.only(
                    start: 0, bottom: 10, end: 0, top: 0),
                title: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text('Daftar feedback',
                        style: AppStyle.textHeadlineTipisBlack),
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            (allFeedback == null)
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
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: AppStyle.colorWhite,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0.0, 1),
                                        blurRadius: 15.0,
                                      )
                                    ],
                                  ), //'${allFeedback[index].deskripsi}'
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      allFeedback[index].image),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      11 /
                                                      16,
                                                  child: Text(
                                                    '${allFeedback[index].name}',
                                                    style: AppStyle.textName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                    '${allFeedback[index].createdAt.day}-${allFeedback[index].createdAt.month}-${allFeedback[index].createdAt.year} ${allFeedback[index].createdAt.hour}:${allFeedback[index].createdAt.minute}:${allFeedback[index].createdAt.second}',
                                                    style:
                                                        AppStyle.textCaption),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text('${allFeedback[index].deskripsi}',
                                            style:
                                                AppStyle.textSubHeadlineBlack),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      },
                      childCount: allFeedback.length,
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
    );
  }

  SafeArea pageForm(BuildContext context) {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // start loading data
            setState(() {
              isLoadingMore = true;
            });
            //load data
            Provider.of<AdminProvider>(context, listen: false)
                .getAllFormMore(token);
          }
          return true;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 65.0,
              floating: false,
              pinned: true,
              backgroundColor: AppStyle.colorBg,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsetsDirectional.only(
                    start: 0, bottom: 10, end: 0, top: 0),
                title: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text('Daftar Request Invitation Key',
                        style: AppStyle.textHeadlineTipisBlack),
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            (allForm == null)
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
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: AppStyle.colorWhite,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0.0, 1),
                                        blurRadius: 15.0,
                                      )
                                    ],
                                  ), //'${allFeedback[index].deskripsi}'
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        (allForm[index].role == 0)
                                            ? Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  'Belum Terverifikasi',
                                                  style: AppStyle
                                                      .textSubHeadingMerah,
                                                ),
                                              )
                                            : Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  'Selesai Terverifikasi',
                                                  style: AppStyle
                                                      .textSubHeadingAbu,
                                                ),
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      allForm[index].userImage),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      11 /
                                                      16,
                                                  child: Text(
                                                    '${allForm[index].name}',
                                                    style: AppStyle.textName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                    '${allForm[index].createdAt.day}-${allForm[index].createdAt.month}-${allForm[index].createdAt.year} ${allForm[index].createdAt.hour}:${allForm[index].createdAt.minute}:${allForm[index].createdAt.second}',
                                                    style:
                                                        AppStyle.textCaption),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text('${allForm[index].email}',
                                            style:
                                                AppStyle.textSubHeadlineBlack),
                                        Text('${allForm[index].nrp}',
                                            style:
                                                AppStyle.textSubHeadlineBlack),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                            __) =>
                                                        FullScreen(
                                                  index: index,
                                                  image:
                                                      allForm[index].verifImage,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: 'fullscreenBug$index',
                                            child: Container(
                                              height: 200,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      new CachedNetworkImageProvider(
                                                          allForm[index]
                                                              .verifImage),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        (isLoading)
                                            ? Container(
                                                width: double.infinity,
                                                height: 38.0,
                                                child: Center(
                                                  child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child:
                                                          CircularProgressIndicator()),
                                                ))
                                            : ListTile(
                                                title: Text(
                                                    'Kirim Invitation key',
                                                    style: AppStyle
                                                        .textSubHeadingAbu),
                                                leading: Icon(MdiIcons.gmail,
                                                    size: 30,
                                                    color: AppStyle.colorMain),
                                                onTap: () async {
                                                  bool _status = await Provider
                                                          .of<AdminProvider>(
                                                              context,
                                                              listen: false)
                                                      .generateKey(token);
                                                  if (_status) {
                                                    bool _status2 = await Provider
                                                            .of<AdminProvider>(
                                                                context,
                                                                listen: false)
                                                        .getAllKey(token);
                                                    print('${allKey[0].key}');
                                                    if (_status2) {
                                                      customLaunch(
                                                          'mailto:${allForm[index].email}?subject=Invitation Key Hima Telkom&body=${allKey[0].key}');
                                                    }
                                                  } else {
                                                    showAlert(context);
                                                  }
                                                },
                                              )
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      },
                      childCount: allForm.length,
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
    );
  }

  SafeArea pageKey(BuildContext context) {
    return SafeArea(
        child: CustomScrollView(
            //controller: scrollControl,
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: AppStyle.colorBg,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(
                  start: 0, bottom: 10, end: 0, top: 0),
              title: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: (isLoading)
                      ? Container(
                          width: double.infinity,
                          height: 38.0,
                          child: Center(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator()),
                          ))
                      : InkWell(
                          onTap: () async {
                            bool _status = await Provider.of<AdminProvider>(
                                    context,
                                    listen: false)
                                .generateKey(token);
                            if (_status) {
                              Provider.of<AdminProvider>(context, listen: false)
                                  .getAllKey(token);
                            } else {
                              showAlert(context);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 38.0,
                            decoration: BoxDecoration(
                              color: AppStyle.colorMain,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Center(
                                child: Text('Generate key',
                                    style: AppStyle.textSubHeading2Putih)),
                          ),
                        ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
              background: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Text(
                      'Daftar invitation key',
                      style: AppStyle.textHeadlineTipisBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          (allKey == null)
              ? SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ) //${allKey[index].key}'
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Material(
                              color: Colors.white.withOpacity(0),
                              child: InkWell(
                                splashColor: AppStyle.colorMain,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 18),
                                  height: 50,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text('${allKey[index].key}',
                                        style: AppStyle.textCaption2),
                                  ),
                                ),
                                onLongPress: () {
                                  Clipboard.setData(new ClipboardData(
                                          text: '${allKey[index].key}'))
                                      .then((_) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            "Key telah disalin clipboard")));
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          )
                        ],
                      );
                    },
                    childCount: allKey.length,
                  ),
                )
        ]));
  }

  SafeArea pageUser(BuildContext context) {
    return SafeArea(
        child: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // start loading data
          setState(() {
            isLoadingMore = true;
          });
          //load data
          (status == 0)
              ? Provider.of<AdminProvider>(context, listen: false)
                  .getAllUserMore(token)
              : Provider.of<AdminProvider>(context, listen: false)
                  .getAllFilterUserMore(status, token);
        }
        return true;
      },
      child: CustomScrollView(
          //controller: scrollControl,
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: AppStyle.colorBg,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsetsDirectional.only(
                    start: 0, bottom: 10, end: 0, top: 0),
                title: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Cari user...',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (newValue) {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) =>
                                      SearchUser(param: newValue, token: token),
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  searchController =
                                      TextEditingController(text: '');
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(Icons.cancel,
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                collapseMode: CollapseMode.parallax,
                background: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Text(
                        'Daftar user',
                        style: AppStyle.textHeadlineTipisBlack,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20, left: 13),
                child: Container(
                  height: 30.0,
                  child: ListView.builder(
                    itemCount: kategoriRole.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      return FittedBox(
                        fit: BoxFit.fitWidth,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // filterPost(kategori[i]);
                              status = i;

                              if (status == 0) {
                                getAllUser();
                              } else {
                                getAllFilterUser(role: status - 1);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
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
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.5)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                            child: Text(
                              '${kategoriRole[i]}',
                              style: (status == i)
                                  ? AppStyle.textSubHeadingPutih
                                  : AppStyle.textSubHeadingAbu,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            (allUser == null && status == 0 ||
                    allFilterUser == null && status != 0)
                ? SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : (status == 0) ? listUser(allUser) : listUser(allFilterUser),
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
          ]),
    ));
  }

  listUser(List user) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: InkWell(
              onLongPress: () {
                setState(() {
                  isEditRole = false;
                });
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
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setModalState) {
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              (isEditRole)
                                  ? SizedBox()
                                  : ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                      ),
                                      title: Text(
                                        'Ganti role',
                                        style: AppStyle.textSubHeadingAbu,
                                      ),
                                      onTap: () {
                                        setModalState(() {
                                          isEditRole = true;
                                        });
                                      },
                                    ),
                              (!isEditRole)
                                  ? SizedBox()
                                  : Container(
                                      height: 50,
                                      child: Center(
                                        child: Text('Ganti role',
                                            style: AppStyle.textSubHeadingAbu),
                                      ),
                                    ),
                              (isEditRole)
                                  ? SizedBox()
                                  : ListTile(
                                      leading: Icon(
                                        Icons.delete_outline,
                                      ),
                                      title: Text(
                                        'Hapus akun',
                                        style: AppStyle.textSubHeadingAbu,
                                      ),
                                      onTap: () async {
                                        String _status = await showDeleteUser(
                                            context, allUser[index].id, token);
                                        if (_status == "ok") {
                                          (status == 0)
                                              ? Provider.of<AdminProvider>(
                                                      context,
                                                      listen: false)
                                                  .getAllUser(token)
                                              : Provider.of<AdminProvider>(
                                                      context,
                                                      listen: false)
                                                  .getAllFilterUser(
                                                      status, token);
                                        }
                                      },
                                    ),
                              (!isEditRole)
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10, left: 13),
                                      child: Container(
                                        height: 30.0,
                                        child: ListView.builder(
                                          itemCount: fixRole.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (_, i) {
                                            return (i == 6)
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 2.0),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        decoration:
                                                            (i == statusRole)
                                                                ? BoxDecoration(
                                                                    color: AppStyle
                                                                        .colorMain,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          50.0),
                                                                    ),
                                                                  )
                                                                : BoxDecoration(
                                                                    color: AppStyle
                                                                        .colorWhite,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.5)),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          50.0),
                                                                    ),
                                                                  ),
                                                        child: Text(
                                                          '${fixRole[i]}',
                                                          style: (statusRole ==
                                                                  i)
                                                              ? AppStyle
                                                                  .textSubHeadingPutih
                                                              : AppStyle
                                                                  .textSubHeadingAbu,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          },
                                        ),
                                      ),
                                    ),
                              (!isEditRole)
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              'Role akan diganti sesuai pilihan',
                                              style: AppStyle.textCaption),
                                          (loadingEditRole)
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : InkWell(
                                                  onTap: () async {
                                                    setModalState(() {
                                                      loadingEditRole = true;
                                                    });
                                                    bool _status = await Provider
                                                            .of<AdminProvider>(
                                                                context,
                                                                listen: false)
                                                        .getEditRole(
                                                            user[index].id,
                                                            statusRole,
                                                            token);
                                                    setModalState(() {
                                                      if (_status) {
                                                        loadingEditRole = false;
                                                        Navigator.pop(context);
                                                        (status == 0)
                                                            ? Provider.of<
                                                                        AdminProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getAllUser(
                                                                    token)
                                                            : Provider.of<
                                                                        AdminProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getAllFilterUser(
                                                                    status - 1,
                                                                    token);
                                                      } else {
                                                        loadingEditRole = false;
                                                        showAlert(context);
                                                      }
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        AppStyle.colorMain,
                                                    radius: 20,
                                                    child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 10)
                            ],
                          ),
                        );
                      });
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppStyle.colorWhite,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0.0, 1),
                      blurRadius: 15.0,
                    )
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                CachedNetworkImageProvider(user[index].image),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 11 / 16,
                            child: Text('${user[index].name}',
                                style: AppStyle.textName,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text('Email : ${user[index].email}',
                          style: AppStyle.textCaption2),
                      Text('Nomer : +${user[index].nomer}',
                          style: AppStyle.textCaption2),
                      Text('NRP : ${user[index].nrp}',
                          style: AppStyle.textCaption2),
                      Text('Angkatan ${user[index].angkatan}',
                          style: AppStyle.textCaption2),
                      Text('Role : ' + fixRole[user[index].role],
                          style: AppStyle.textCaption2),
                      Text(
                          'Akun dibuat : ${user[index].createdAt.day}-${user[index].createdAt.month}-${user[index].createdAt.year}',
                          style: AppStyle.textCaption2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: user.length,
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
            tag: 'fullscreenBug$index',
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
        ),
      ),
    );
  }
}

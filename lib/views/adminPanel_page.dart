import 'package:discussion_app/models/allUser_model.dart';
import 'package:discussion_app/models/feedback_model.dart';
import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminPanel extends StatefulWidget {
  final String token;
  AdminPanel({Key key, @required this.token}) : super(key: key);
  @override
  _AdminPanelState createState() => _AdminPanelState(token: token);
}

class _AdminPanelState extends State<AdminPanel> {
  final String token;
  _AdminPanelState({Key key, @required this.token});

  //*Page View
  int bottomNavBarIndex;
  PageController pageController;
  // bottomNavBarIndex = 0;
  // pageController = PageController(initialPage: bottomNavBarIndex);
  //*

  //* VARIABLE
  var allKey;
  List<Datum> allUser;
  var isLoading;
  bool isLoadingMore;
  List<DatumFeedback> allFeedback;

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

  //* GET ALL USER DATA
  void getAllUser() {
    Provider.of<AdminProvider>(context, listen: false).getAllUser(token);
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
    isLoading = Provider.of<AdminProvider>(context).isLoading ?? false;
    isLoadingMore = Provider.of<AdminProvider>(context).isLoadingMore ?? false;
    allFeedback = Provider.of<AdminProvider>(context).allFeedback ?? null;

    return Scaffold(
      backgroundColor: AppStyle.colorBg,
      body: Container(
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
                        .getAllFeedback(token);
                  }
                  if (index == 2) {
                    Provider.of<AdminProvider>(context, listen: false)
                        .getAllKey(token);
                  }
                });
              },
              children: <Widget>[
                //* page user
                pageUser(context),
                //* page feedback
                pageFeedback(context),
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
                        MdiIcons.thumbsUpDown,
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
                                                Text(
                                                    '${allFeedback[index].name}',
                                                    style: AppStyle.textName),
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
          Provider.of<AdminProvider>(context, listen: false)
              .getAllUserMore(token);
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
                        child: TextField(
                          //controller: searchController,
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
                          onSubmitted: (newValue) {},
                        ),
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
            (allUser == null)
                ? SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : SliverList(
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
                                        (BuildContext context,
                                            StateSetter setModalState) {
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
                                                      style: AppStyle
                                                          .textSubHeadingAbu,
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
                                                          style: AppStyle
                                                              .textSubHeadingAbu),
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
                                                      style: AppStyle
                                                          .textSubHeadingAbu,
                                                    ),
                                                    onTap: () async {
                                                      String _status =
                                                          await showDeleteUser(
                                                              context,
                                                              allUser[index].id,
                                                              token);
                                                      if (_status == "ok") {
                                                        Provider.of<AdminProvider>(
                                                                context,
                                                                listen: false)
                                                            .getAllUser(token);
                                                      }
                                                    },
                                                  ),
                                            (!isEditRole)
                                                ? SizedBox()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            left: 13),
                                                    child: Container(
                                                      height: 30.0,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            fixRole.length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder: (_, i) {
                                                          return (i == 6)
                                                              ? SizedBox()
                                                              : FittedBox(
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      setModalState(
                                                                          () {
                                                                        statusRole =
                                                                            i;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0,
                                                                          vertical:
                                                                              2.0),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                      decoration: (i ==
                                                                              statusRole)
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
                                                                      child:
                                                                          Text(
                                                                        '${fixRole[i]}',
                                                                        style: (statusRole ==
                                                                                i)
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
                                            (!isEditRole)
                                                ? SizedBox()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18.0,
                                                        vertical: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                            'Role akan diganti sesuai pilihan',
                                                            style: AppStyle
                                                                .textCaption),
                                                        (loadingEditRole)
                                                            ? Center(
                                                                child:
                                                                    CircularProgressIndicator())
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  setModalState(
                                                                      () {
                                                                    loadingEditRole =
                                                                        true;
                                                                  });
                                                                  bool _status = await Provider.of<
                                                                              AdminProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getEditRole(
                                                                          allUser[index]
                                                                              .id,
                                                                          statusRole,
                                                                          token);
                                                                  setModalState(
                                                                      () {
                                                                    if (_status) {
                                                                      loadingEditRole =
                                                                          false;
                                                                      Navigator.pop(
                                                                          context);
                                                                      Provider.of<AdminProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .getAllUser(
                                                                              token);
                                                                    } else {
                                                                      loadingEditRole =
                                                                          false;
                                                                      showAlert(
                                                                          context);
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      AppStyle
                                                                          .colorMain,
                                                                  radius: 20,
                                                                  child: Icon(Icons
                                                                      .arrow_forward_ios),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  allUser[index].image),
                                        ),
                                        SizedBox(width: 10),
                                        Text('${allUser[index].name}',
                                            style: AppStyle.textName),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Text('Email : ${allUser[index].email}',
                                        style: AppStyle.textCaption2),
                                    Text('NRP : ${allUser[index].nrp}',
                                        style: AppStyle.textCaption2),
                                    Text('Angkatan ${allUser[index].angkatan}',
                                        style: AppStyle.textCaption2),
                                    Text(
                                        'Role : ' +
                                            fixRole[allUser[index].role],
                                        style: AppStyle.textCaption2),
                                    Text(
                                        'Akun dibuat : ${allUser[index].createdAt.day}-${allUser[index].createdAt.month}-${allUser[index].createdAt.year}',
                                        style: AppStyle.textCaption2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: allUser.length,
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
          ]),
    ));
  }
}

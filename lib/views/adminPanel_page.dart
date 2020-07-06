import 'package:discussion_app/models/allUser_model.dart';
import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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

  //*
  @override
  void initState() {
    super.initState();

    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
  }

  @override
  Widget build(BuildContext context) {
    allKey = Provider.of<AdminProvider>(context).allKey ?? null;
    allUser = Provider.of<AdminProvider>(context).allUser ?? null;
    isLoading = Provider.of<AdminProvider>(context).isLoading ?? false;
    isLoadingMore = Provider.of<AdminProvider>(context).isLoadingMore ?? false;
    return Scaffold(
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
                        .getAllKey(token);
                  }
                });
              },
              children: <Widget>[
                //* page user
                SafeArea(
                    child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoadingMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide.none),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        hintText: 'Cari user...',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                    'Data user',
                                    style: AppStyle.textHeadlineTipisBlack,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 100)),
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
                                    return Column(
                                      children: <Widget>[
                                        //*
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 18),
                                            height: 50,
                                            width: double.infinity,
                                            child: Center(
                                              child: Text(
                                                  '${allUser[index].name}',
                                                  style: AppStyle.textCaption2),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                      ],
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
                )),
                //* page key
                SafeArea(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
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
                                        bool _status =
                                            await Provider.of<AdminProvider>(
                                                    context,
                                                    listen: false)
                                                .generateKey(token);
                                        if (_status) {
                                          Provider.of<AdminProvider>(context,
                                                  listen: false)
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
                                                style: AppStyle
                                                    .textSubHeading2Putih)),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
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
                                                child: Text(
                                                    '${allKey[index].key}',
                                                    style:
                                                        AppStyle.textCaption2),
                                              ),
                                            ),
                                            onLongPress: () {
                                              Clipboard.setData(new ClipboardData(
                                                      text:
                                                          '${allKey[index].key}'))
                                                  .then((_) {
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Key telah disalin clipboard")));
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
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
                    ])),
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
}

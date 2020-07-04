import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/ClipPathHome.dart';
import 'package:discussion_app/utils/ClipShadowPath.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/create_post.dart';
import 'package:discussion_app/views/detail_page.dart';
import 'package:discussion_app/views/editPost_page.dart';
import 'package:discussion_app/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:discussion_app/views/editProfil_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int bottomNavBarIndex;
  PageController pageController;
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
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _iconColorTween = ColorTween(begin: Colors.grey, end: AppStyle.colorMain)
        .animate(_colorAnimationController);
    _opacityTween =
        Tween<double>(begin: 0, end: 1).animate(_colorAnimationController);
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(0, 40), end: Offset(0, 0))
        .animate(_textAnimationController);

    Future.microtask(() {
      Provider.of<PostProvider>(context, listen: false).getAllPost();
      Provider.of<PostProvider>(context, listen: false).getDetailProfil();
    });

    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 125);
      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 125) / 50);
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
    Provider.of<PostProvider>(context, listen: false).getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    List kategori = [
      'Semua',
      'Forum Alumni',
      'Kompetisi',
      'Mata Kuliah',
      'Beasiswa',
      'Keluh kesah'
    ];
    allPost = Provider.of<PostProvider>(context).allPost ?? null;
    String name = Provider.of<AuthProvider>(context).name;
    List nameSplit = name.split(' ');
    String profil = Provider.of<AuthProvider>(context).profil;
    var filterPost = Provider.of<PostProvider>(context).filterPost ?? null;
    var detailProfil = Provider.of<PostProvider>(context).detailProfil ?? null;
    tokenProvider = Provider.of<AuthProvider>(context).token;
    int role = Provider.of<AuthProvider>(context).role;
    int idUser = Provider.of<AuthProvider>(context).idUser;
    isLoading = Provider.of<PostProvider>(context).isLoading ?? null;
    return Scaffold(
      backgroundColor: AppStyle.colorBg,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: AppStyle.colorBg,
            ),
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  bottomNavBarIndex = index;

                  if (index == 0) {
                    Provider.of<PostProvider>(context, listen: false)
                        .getAllPost();
                  }
                  if (index == 1) {
                    Provider.of<PostProvider>(context, listen: false)
                        .getDetailProfil();
                  }
                });
              },
              children: <Widget>[
                // HALAMAN HOME PAGE / MAIN PAGE
                mainPage(name, nameSplit[0], profil, kategori, allPost,
                    filterPost, role, idUser),

                //HALAMAN PROFIL
                profilPage(detailProfil, name, profil, role, idUser)
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[],
                  ),
                ),
              ),
            ),
            customNavBar(),
            createPostButton(context)
          ],
        ),
      ),
    );
  }

  NotificationListener profilPage(
      detailProfil, String name, String profil, role, idUser) {
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Container(
                                  margin: EdgeInsets.only(top: 100),
                                  height: 330,
                                  decoration: BoxDecoration(
                                    color: AppStyle.colorWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                                        backgroundImage:
                                            CachedNetworkImageProvider(profil),
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
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      '$role',
                                      style: AppStyle.textSubHeadlineBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      'Angkatan ${detailProfil.user.angkatan}',
                                      style: AppStyle.textSubHeadlineBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      '${detailProfil.user.nrp}',
                                      style: AppStyle.textSubHeadlineBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 34.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditProfil(
                                              image: profil,
                                              name: name,
                                              angkatan:
                                                  detailProfil.user.angkatan,
                                              token: tokenProvider,
                                            ),
                                          ),
                                        );
                                        // submit();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppStyle.colorMain,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Edit Profil',
                                          style: AppStyle.textSubHeading2Putih,
                                        )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 34.0),
                                    child: InkWell(
                                      onTap: () {
                                        submit();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppStyle.colorMain,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Logout',
                                          style: AppStyle.textSubHeading2Putih,
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text('Thread', style: AppStyle.textList),
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

  Align createPostButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
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
            String _create = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePost(
                  token: tokenProvider,
                ),
              ),
            );
            setState(() {
              print(_create);
              if (_create == 'ok') {
                getdata();
                _create = "";
              }
            });
          },
        ),
      ),
    );
  }

  Align customNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
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
    );
  }

  SafeArea mainPage(String name, String nameSplit, String profil, List kategori,
      allPost, filterPost, int role, idUser) {
    return SafeArea(
      child: CustomScrollView(
        controller: scrollControl,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
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
                          hintText: 'Cari diskusi...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (newValue) {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  SearchPage(search: newValue),
                            ),
                          );
                        },
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
                  children: <Widget>[
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Hai,',
                              style: AppStyle.textHeadlineTipisBlack,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                        13 /
                                        16 -
                                    36,
                                child: Text(
                                  '$name',
                                  style: AppStyle.textHeadlineBlack,
                                ),
                              ),
                            )
                          ],
                        ),
                        Hero(
                          tag: 'profil',
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(profil),
                          ),
                        ),
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
            sliver: (allPost == null && status == 0 ||
                    filterPost == null && status != 0)
                ? SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : (status != 0)
                    ? listAllPost(filterPost, name, role, idUser)
                    : listAllPost(allPost, name, role, idUser),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverList listAllPost(allPost, name, role, idUser) {
    return SliverList(
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
                    return (allPost[index].userId == idUser || role == 6)
                        ? Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              ListTile(
                                leading: Icon(
                                  Icons.warning,
                                ),
                                title: Text(
                                  'Laporkan thread',
                                  style: AppStyle.textSubHeadingAbu,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              ListTile(
                                  leading: Icon(
                                    Icons.edit,
                                  ),
                                  title: Text(
                                    'Edit thread',
                                    style: AppStyle.textSubHeadingAbu,
                                  ),
                                  onTap: () async {
                                    String _statusEdit = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPost(
                                          token: tokenProvider,
                                          postId: allPost[index].id,
                                          idPost: allPost[index],
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      print(_statusEdit);
                                      if (_statusEdit == 'ok') {
                                        getdata();
                                        _statusEdit = "";
                                      }
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
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
                                  String _status = await showDelete(context,
                                      allPost[index].id, tokenProvider, role);
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
                                  Icons.warning,
                                ),
                                title: Text(
                                  'Laporkan thread',
                                  style: AppStyle.textSubHeadingAbu,
                                ),
                              ),
                            ],
                          );
                  },
                );
              },
              onTap: () async {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Provider.of<PostProvider>(context, listen: false)
                      .getIdPost(allPost[index].id, tokenProvider);
                });
                String _status = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
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
                            image: new CachedNetworkImageProvider(
                                allPost[index].postImage),
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
                              '${allPost[index].name}',
                              style: AppStyle.textBody1,
                            ),
                            Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width * 6 / 10,
                              child: Text(
                                '${allPost[index].title}',
                                style: AppStyle.textRegular,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Text(
                              '${allPost[index].kategori}',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
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
                          border:
                              Border.all(color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                  child: Text(
                    '${kategori[i]}',
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
    );
  }
}

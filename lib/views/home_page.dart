import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/ClipPathHome.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/detail_page.dart';
import 'package:discussion_app/views/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int status = 0;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    Provider.of<PostProvider>(context, listen: false).getAllPost();
    super.initState();
  }

  void submit() {
    Provider.of<AuthProvider>(context, listen: false).logOut();
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
    var allPost = Provider.of<PostProvider>(context).allPost ?? null;
    String name = Provider.of<AuthProvider>(context).name;
    String profil = Provider.of<AuthProvider>(context).profil;
    var filterPost = Provider.of<PostProvider>(context).filterPost ?? null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              floating: true,
              backgroundColor: Color(0xFFFAFAFA),
              expandedHeight: 225.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                centerTitle: true,
                background: Stack(
                  children: <Widget>[
                    ClipPath(
                      child: header(name),
                      clipper: CustomClipPathHome(),
                    ),
                    createPost(profil),
                    kategoriListView(kategori)
                  ],
                ),
              ),
            ),
            (allPost == null && status == 0 ||
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
                    ? filterKategoriPost(filterPost)
                    : listAllPost(allPost),
          ],
        ),
      ),
    );
  }

  SliverList filterKategoriPost(filterPost) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    id: filterPost[index].id,
                    image: filterPost[index].postImage,
                    index: index,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              width: double.infinity,
              height: 100.0,
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: 'fullscreen${filterPost[index].id}',
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new CachedNetworkImageProvider(
                              filterPost[index].postImage),
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
                            '${filterPost[index].name}',
                            style: AppStyle.textBody1,
                          ),
                          Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 6 / 10,
                            child: Text(
                              '${filterPost[index].title}',
                              style: AppStyle.textRegular,
                            ),
                          ),
                          Text(
                            '${filterPost[index].kategori}',
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
        );
      }, childCount: filterPost.length),
    );
  }

  SliverList listAllPost(allPost) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    id: allPost[index].id,
                    image: allPost[index].postImage,
                    index: index,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
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
        );
      }, childCount: allPost.length),
    );
  }

  Container header(String name) {
    return Container(
      height: 220.0,
      width: double.infinity,
      color: AppStyle.colorMain,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Hello',
                  textAlign: TextAlign.left, style: AppStyle.textHeadlineWhite),
              Expanded(
                child: Text(
                  '$name',
                  textAlign: TextAlign.left,
                  style: AppStyle.textHeadlineWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding createPost(String profil) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        margin: EdgeInsets.only(top: 185.0),
        width: double.infinity,
        height: 80.0,
        decoration: AppStyle.decorationCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Hero(
                tag: 'profil',
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(profil),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/create-post');
                  },
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: AppStyle.colorWhite,
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              'Mulai diskusi',
                              style: AppStyle.textSubHeadingAbu,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container kategoriListView(List kategori) {
    return Container(
      margin: EdgeInsets.only(top: 280, left: 13),
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
    );
  }

  CustomAppBar customAppBar() {
    return CustomAppBar(
      height: 85.0,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      onPressed: (null)),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 20,
                  child: InkWell(
                    onTap: null,
                    child: Container(
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: TextField(
                        controller: searchController,
                        style: AppStyle.textSearchPutih,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white54,
                          ),
                          hintStyle: TextStyle(color: Colors.white54),
                          hintText: 'Cari diskusi',
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
                      /*child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text(
                              'Cari diskusi',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.search,
                              size: 30.0,
                              color: Colors.white.withOpacity(0.6),
                            )
                          ],
                        ),
                      ), */
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0, color: AppStyle.colorMain),
        color: AppStyle.colorMain,
      ),
      height: preferredSize.height,
      alignment: Alignment.center,
      child: child,
    );
  }
}
/*
class HomePages extends StatelessWidget {
  //final String status;
  //HomePage({Key key, @required this.status}) : super(key: key);

/*  void didChangeDepedencies(){
    super.didChangeDepedencies();
    
  }
  */

  @override
  Widget build(BuildContext context) {
    void submit() {
      Provider.of<AuthProvider>(context, listen: false).logOut();
    }

    void delete() {
      Provider.of<PostProvider>(context, listen: false).deletePost(22);
    }

    void getdata() {
      Provider.of<PostProvider>(context, listen: false).getAllPost();
      Provider.of<PostProvider>(context, listen: false).getIdPost(4);
    }

    var allPost = Provider.of<PostProvider>(context).allPost ?? '';
    var idPost = Provider.of<PostProvider>(context).idPost ?? null;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: submit,
              child: Text('Logout'),
            ),
            RaisedButton(
              onPressed: getdata,
              child: Text('get'),
            ),
            RaisedButton(
              onPressed: delete,
              child: Text('delete'),
            ),
            SizedBox(
              height: 100.0,
              child: ListView.builder(
                  itemCount: allPost.length,
                  itemBuilder: (context, i) {
                    return Text('${allPost[i].title}');
                  }),
            ),
            (idPost == null)
                ? Text('aw')
                : SizedBox(
                    height: 100.0,
                    child: ListView.builder(
                        itemCount: idPost.komentar.length,
                        itemBuilder: (context, i) {
                          return Text('${idPost.komentar[i].name}');
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}

*/

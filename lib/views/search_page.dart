import 'package:discussion_app/models/searchUser_model.dart';
import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:discussion_app/widgets/placeholder.dart';

class SearchPage extends StatefulWidget {
  final String search;
  final String token;
  final String name;
  final int role;
  final int idUser;
  SearchPage({Key key, @required this.search, this.token, this.name, this.role, this.idUser}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState(search: search, token: token, name: name, role: role, idUser: idUser);
}

class _SearchPageState extends State<SearchPage> {
  final String search;
  final String token;
  final String name;
  final int role;
  final int idUser;
  _SearchPageState({Key key, @required this.search, this.token, this.name, this.role, this.idUser});

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<PostProvider>(context, listen: false).getSearchPost(search, token);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchPost = Provider.of<PostProvider>(context).searchPost;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: SafeArea(
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
          child: (searchPost == null)
              ? ListView(
                children: <Widget>[
                  PlaceHolder(),
                ],
              )
              : (searchPost.posts.length <= 0 && searchPost.msg != null)
                  ? SizedBox()
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        id: searchPost.posts[index].id,
                                        image: searchPost.posts[index].postImage,
                                        index: index,
                                        token: token,
                                        name: name,
                                        role: role,
                                        idUser: idUser,
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
                                        tag: 'fullscreen${searchPost.posts[index].id}',
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new CachedNetworkImageProvider(searchPost.posts[index].postImage),
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
                                                '${searchPost.posts[index].name}',
                                                style: AppStyle.textBody1,
                                              ),
                                              Container(
                                                height: 50.0,
                                                width: MediaQuery.of(context).size.width * 6 / 10,
                                                child: Text(
                                                  '${searchPost.posts[index].title}',
                                                  style: AppStyle.textRegular,
                                                ),
                                              ),
                                              Text(
                                                '${searchPost.posts[index].kategori}',
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
                          }, childCount: searchPost.posts.length),
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}

//* SEARCH USER
class SearchUser extends StatefulWidget {
  final String param;
  final String token;
  SearchUser({Key key, @required this.param, this.token}) : super(key: key);
  @override
  _SearchUserState createState() => _SearchUserState(param: param, token: token);
}

class _SearchUserState extends State<SearchUser> {
  final String param;
  final String token;
  _SearchUserState({Key key, @required this.param, this.token});

  List<DatumSearch> user = List<DatumSearch>();

  int statusRole = 0;
  bool isEditRole = false;
  bool loadingEditRole = false;
  int status = 0;

  List fixRole = ['Guest', 'Mahasiswa Aktif', 'Fungsionaris', 'Alumni', 'Dosen', 'Admin', 'Developer'];

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<AdminProvider>(context, listen: false).getSearchUser(param, token);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AdminProvider>(context).allSearchUser;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: SafeArea(
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
          child: (user == null)
              ? Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : (user.length <= 0)
                  ? SizedBox()
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverList(
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
                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState) {
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
                                                            child: Text('Ganti role', style: AppStyle.textSubHeadingAbu),
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
                                                            String _status = await showDeleteUser(context, user[index].id, token);
                                                            if (_status == "ok") {
                                                              Provider.of<AdminProvider>(context, listen: false).getSearchUser(param, token);
                                                            }
                                                          },
                                                        ),
                                                  (!isEditRole)
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 13),
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
                                                                              '${fixRole[i]}',
                                                                              style: (statusRole == i) ? AppStyle.textSubHeadingPutih : AppStyle.textSubHeadingAbu,
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
                                                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Text('Role akan diganti sesuai pilihan', style: AppStyle.textCaption),
                                                              (loadingEditRole)
                                                                  ? Center(child: CircularProgressIndicator())
                                                                  : InkWell(
                                                                      onTap: () async {
                                                                        setModalState(() {
                                                                          loadingEditRole = true;
                                                                        });
                                                                        bool _status = await Provider.of<AdminProvider>(context, listen: false).getEditRole(user[index].id, statusRole, token);
                                                                        setModalState(() {
                                                                          if (_status) {
                                                                            loadingEditRole = false;
                                                                            Navigator.pop(context);
                                                                            Provider.of<AdminProvider>(context, listen: false).getSearchUser(param, token);
                                                                          } else {
                                                                            loadingEditRole = false;
                                                                            showAlert(context);
                                                                          }
                                                                        });
                                                                      },
                                                                      child: CircleAvatar(
                                                                        backgroundColor: AppStyle.colorMain,
                                                                        radius: 20,
                                                                        child: Icon(Icons.arrow_forward_ios),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
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
                                                backgroundImage: CachedNetworkImageProvider(user[index].image),
                                              ),
                                              SizedBox(width: 10),
                                              Text('${user[index].name}', style: AppStyle.textName),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Text('Email : ${user[index].email}', style: AppStyle.textCaption2),
                                          Text('NRP : ${user[index].nrp}', style: AppStyle.textCaption2),
                                          Text('Angkatan ${user[index].angkatan}', style: AppStyle.textCaption2),
                                          Text('Role : ' + fixRole[user[index].role], style: AppStyle.textCaption2),
                                          Text('Akun dibuat : ${user[index].createdAt.day}-${user[index].createdAt.month}-${user[index].createdAt.year}', style: AppStyle.textCaption2),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: user.length,
                          ),
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}

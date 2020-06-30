import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchPage extends StatefulWidget {
  final String search;
  SearchPage({Key key, @required this.search}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState(search: search);
}

class _SearchPageState extends State<SearchPage> {
  final String search;
  _SearchPageState({Key key, @required this.search});

  @override
  void initState() {
    Provider.of<PostProvider>(context, listen: false).getSearchPost(search);
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
                ? Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : (searchPost.posts.length <= 0 && searchPost.msg != null)
                    ? Text('0')
                    : CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          id: searchPost.posts[index].id,
                                          image:
                                              searchPost.posts[index].postImage,
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
                                          tag:
                                              'fullscreen${searchPost.posts[index].id}',
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              image: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    new CachedNetworkImageProvider(
                                                        searchPost.posts[index]
                                                            .postImage),
                                              ),
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${searchPost.posts[index].name}',
                                                  style: AppStyle.textBody1,
                                                ),
                                                Container(
                                                  height: 50.0,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      6 /
                                                      10,
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
                      )),
      ),
    );
  }
}

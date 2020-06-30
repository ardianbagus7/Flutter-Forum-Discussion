import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/views/komentar_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final int index;
  final String image;
  DetailPage({Key key, @required this.id, this.image, this.index})
      : super(key: key);
  @override
  _DetailPageState createState() =>
      _DetailPageState(index: index, id: id, image: image);
}

class _DetailPageState extends State<DetailPage> {
  final int id;
  final int index;
  final String image;

  _DetailPageState({Key key, @required this.index, this.id, this.image});

  void initState() {
    Provider.of<PostProvider>(context, listen: false).getIdPost(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var detailPost = Provider.of<PostProvider>(context).idPost ?? null;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Diskusi'),
              backgroundColor: AppStyle.colorMain,
              expandedHeight: MediaQuery.of(context).size.height / 3,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
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
          ];
        }, //detailPost.post[0].title
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: (detailPost == null)
                ? Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            foregroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(
                                detailPost.post[0].userImage),
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
                                    width: MediaQuery.of(context).size.width *
                                        7 /
                                        10,
                                    child: Text(
                                      '${detailPost.post[0].name}',
                                      style: AppStyle.textName,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${detailPost.post[0].createdAt.day}-${detailPost.post[0].createdAt.month}-${detailPost.post[0].createdAt.year}',
                                  style: AppStyle.textCaption,
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
                          Provider.of<PostProvider>(context, listen: false).getIdPost(id);
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  KomentarScreen(detailPost: detailPost),
                            ),
                          );
                          //komentarSheet(context, detailPost);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.mode_comment,
                                color: Colors.grey, size: 25),
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

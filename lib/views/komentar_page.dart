import 'dart:async';

import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/utils/showAlert.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class KomentarScreen extends StatefulWidget {
  final detailPost;
  KomentarScreen({Key key, @required this.detailPost}) : super(key: key);
  @override
  _KomentarScreenState createState() =>
      _KomentarScreenState(detailPost: detailPost);
}

class _KomentarScreenState extends State<KomentarScreen> {
  var statusKomentar;
  TextEditingController komentarController = TextEditingController();
  final detailPost;
  _KomentarScreenState({Key key, @required this.detailPost});
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var detailPostNew = Provider.of<PostProvider>(context).idPost ?? null;
    statusKomentar = Provider.of<PostProvider>(context).statusKomentar;

    void submit(String id) async {
      bool status1 = await Provider.of<PostProvider>(context, listen: false)
          .createKomentar(id, komentarController.text);
      bool status2 = await Provider.of<PostProvider>(context, listen: false)
          .getIdPost(detailPost.post[0].id);
      if (status1 && status2) {
        komentarController = TextEditingController(text: '');
        Timer(
          Duration(milliseconds: 0),
          () {
            _controller.jumpTo(_controller.position.maxScrollExtent);
          },
        );
      } else {
        setState(() {
          statusKomentar = 'menunggu';
          showAlert(context);
        });
      }
    }

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
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: (detailPostNew == null)
                    ? Center(
                        child: SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        controller: _controller,
                        itemCount: detailPostNew.komentar.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 20,
                                  foregroundColor: Colors.grey,
                                  backgroundImage: CachedNetworkImageProvider(
                                      detailPostNew.komentar[index].image),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE2E2E2),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 10.0),
                                    width: MediaQuery.of(context).size.width *
                                        13 /
                                        16,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${detailPostNew.komentar[index].name}',
                                            style: AppStyle.textName,
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            '${detailPostNew.komentar[index].komentar}',
                                            style:
                                                AppStyle.textSubHeadlineBlack,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Container(
                width: double.infinity,
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0.0, -0.5),
                      blurRadius: 15.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Container(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            maxLength: 1000,
                            controller: komentarController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Komentar..',
                            ),
                          ),
                        ),
                      ),
                      (statusKomentar != 'loading')
                          ? IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                submit('${detailPost.post[0].id}');
                              },
                            )
                          : Center(
                              child: SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: new CircularProgressIndicator(),
                              ),
                            )
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
}

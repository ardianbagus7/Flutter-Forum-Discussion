import 'dart:math';

import 'package:flutter/material.dart';

class PlaceHolder extends StatefulWidget {
  @override
  _PlaceHolderState createState() => _PlaceHolderState();
}

class _PlaceHolderState extends State<PlaceHolder> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.repeat(reverse: true);
      }
    });
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: <Widget>[
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
          SizedBox(height: 10),
          placeHolderPost(context),
        ],
      ),
    );
  }

  Opacity placeHolderPost(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 4 / 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 6 / 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 2 / 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceHolderDetailPost extends StatefulWidget {
  @override
  _PlaceHolderDetailPostState createState() => _PlaceHolderDetailPostState();
}

class _PlaceHolderDetailPostState extends State<PlaceHolderDetailPost> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.repeat(reverse: true);
      }
    });
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Opacity(
          opacity: animation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 6 / 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 2 / 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 7 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 9 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 9 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 9 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 9 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 9 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 4 / 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlaceHolderKomentar extends StatefulWidget {
  @override
  _PlaceHolderKomentarState createState() => _PlaceHolderKomentarState();
}

class _PlaceHolderKomentarState extends State<PlaceHolderKomentar> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  double randomHeight() {
    return Random().nextDouble() * (200 - 100) + 100;
  }

  int randomWidth() {
    return 6 + Random().nextInt(8 - 6);
  }

  int width1;
  double height1;
  int width2;
  double height2;
  int width3;
  double height3;
  int width4;
  double height4;

  void initState() {
    super.initState();

    width1 = randomWidth();
    height1 = randomHeight();
    width2 = randomWidth();
    height2 = randomHeight();
    width3 = randomWidth();
    height3 = randomHeight();
    width4 = randomWidth();
    height4 = randomHeight();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
        setState(() {
          width1 = randomWidth();
          height1 = randomHeight();
          width2 = randomWidth();
          height2 = randomHeight();
          width3 = randomWidth();
          height3 = randomHeight();
          width4 = randomWidth();
          height4 = randomHeight();
        });
      }
    });
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          placeHolderKomentar(context,width1),
          SizedBox(height: 20),
          placeHolderKomentar(context,width2),
          SizedBox(height: 20),
          placeHolderKomentar(context,width3),
          SizedBox(height: 20),
          placeHolderKomentar(context,width4),
        ],
      ),
    );
  }

  Opacity placeHolderKomentar(BuildContext context, int width) {
    return Opacity(
      opacity: animation.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        height: height1,
                        width: MediaQuery.of(context).size.width * width / 10,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

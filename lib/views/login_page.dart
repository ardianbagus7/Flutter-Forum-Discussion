import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/utils/ClipPathHome.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/widgets/notification_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discussion_app/utils/animation/fade.dart';

class LandingPage extends StatefulWidget {
  final String status;
  LandingPage({Key key, @required this.status}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState(status: status);
}

class _LandingPageState extends State<LandingPage> {
  final String status;
  _LandingPageState({Key key, @required this.status});

  //*loading button
  bool isLoading = false;

  //* PAGE 1 (GET STARTED)
  double yHeightLanding;
  double yOffsetButton = 0;

  //* PAGE SIGNIN / SIGNUP
  int signin = 2;
  int signup = 2;

  //* NAVIGASI
  bool navigasiLanding = true;

  //* void NAVIGASI
  void landing() {
    setState(() {
      yHeightLanding = MediaQuery.of(context).size.height * 4 / 16;
      yOffsetButton = navigasiLanding ? 0 : 250;
      if (!navigasiLanding) {
        signin = 1;
      } else {
        signin = 0;
      }
    });
  }

  //* Text field
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController angkatanController = TextEditingController();

  //* SIGN IN
  void getSignin() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<AuthProvider>(context, listen: false)
        .signin(emailController.text, passwordController.text);
    setState(() {
      isLoading = false;
    });
  }

  //* SIGN UP
  void getSignup() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<AuthProvider>(context, listen: false).signup(
        email: emailController.text,
        angkatan: angkatanController.text,
        nama: namaController.text,
        password: passwordController.text);
    setState(() {
      isLoading = false;
    });
  }

  //* INIT STATE
  @override
  /*void initState() {
    super.initState();
   heightLanding = MediaQuery.of(context).size.width *13 / 16;
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //* Background main
                  ClipPath(
                    clipper: CustomClipLanding(),
                    child: AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 1000),
                      width: MediaQuery.of(context).size.width,
                      height: (!navigasiLanding)
                          ? yHeightLanding
                          : MediaQuery.of(context).size.height * 13 / 16,
                      color: AppStyle.colorMain,
                    ),
                  ),

                  //*Button get started

                  (!navigasiLanding)
                      ? SizedBox()
                      : Center(
                          child: AnimatedContainer(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    14 /
                                    16),
                            duration: Duration(milliseconds: 500),
                            height: 50,
                            width: 250,
                            curve: Curves.easeInOut,
                            transform:
                                Matrix4.translationValues(0, yOffsetButton, 0),
                            decoration: BoxDecoration(
                              color: AppStyle.colorWhite,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0.0, 2),
                                  blurRadius: 15.0,
                                )
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  navigasiLanding = !navigasiLanding;
                                  landing();
                                });
                              },
                              child: Center(
                                child: Text('Get started'),
                              ),
                            ),
                          ),
                        )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 1 / 18),

              //* SIGNIN

              (signin == 2)
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width - 18 - 18,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (signin == 1)
                                ? FadeInUp(
                                    1.5,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text('Email',
                                            style: AppStyle.textSubHeadingAbu)))
                                : SizedBox(),
                            (signin == 1)
                                ? FadeInUp(1.75, emailSignin())
                                : SizedBox(),
                            (signin == 1)
                                ? FadeInUp(
                                    2,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text('Password',
                                            style: AppStyle.textSubHeadingAbu)))
                                : SizedBox(),
                            (signin == 1)
                                ? FadeInUp(2.25, passwordSignin())
                                : SizedBox(),
                            SizedBox(height: 10),
                            (signin == 1)
                                ? FadeInUp(2.5, signinButton())
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),

              //* SIGNUP
              (signup == 2)
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width - 18 - 18,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (signup == 1)
                                ? FadeInUp(
                                    1.5,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text('Nama',
                                            style: AppStyle.textSubHeadingAbu)))
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(1.75, namaSignup())
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(
                                    2,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text('Angkatan',
                                            style: AppStyle.textSubHeadingAbu)))
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(2.25, angkatanSignup())
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(
                                    2.5,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text('Email',
                                            style: AppStyle.textSubHeadingAbu)))
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(2.75, emailSignin())
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(
                                    3,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text('Password',
                                            style: AppStyle.textSubHeadingAbu)))
                                : SizedBox(),
                            (signup == 1)
                                ? FadeInUp(3.25, passwordSignin())
                                : SizedBox(),
                            SizedBox(height: 10),
                            (signup == 1)
                                ? FadeInUp(3.5, signupButton())
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Padding signinButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          (!isLoading)
              ? InkWell(
                  onTap: () {
                    getSignin();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppStyle.colorMain,
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
                    child: Center(
                        child: Text('Masuk',
                            style: AppStyle.textSubHeading2Putih)),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: new CircularProgressIndicator(),
                  ),
                ),
          SizedBox(height: 10),
          Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ?? NotificationText(''),
          ),
          SizedBox(height: 5),
          InkWell(
            onTap: () {
              setState(() {
                signup = 1;
                signin = 2;
                emailController = TextEditingController(text: '');
                passwordController = TextEditingController(text: '');
                namaController = TextEditingController(text: '');
                angkatanController = TextEditingController(text: '');
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Belum punya akun? ', style: AppStyle.textCaption2tipis),
                Text('Daftar sekarang', style: AppStyle.textCaption2)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding signupButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          (!isLoading)
              ? InkWell(
                  onTap: () {
                    getSignup();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppStyle.colorMain,
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
                    child: Center(
                        child: Text('Daftar',
                            style: AppStyle.textSubHeading2Putih)),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: new CircularProgressIndicator(),
                  ),
                ),
          SizedBox(height: 10),
          Consumer<AuthProvider>(
            builder: (context, provider, child) =>
                provider.notification ?? NotificationText(''),
          ),
          SizedBox(height: 5),
          InkWell(
            onTap: () {
              setState(() {
                signup = 2;
                signin = 1;
                emailController = TextEditingController(text: '');
                passwordController = TextEditingController(text: '');
                namaController = TextEditingController(text: '');
                angkatanController = TextEditingController(text: '');
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Sudah punya akun? ', style: AppStyle.textCaption2tipis),
                Text('Masuk sekarang', style: AppStyle.textCaption2)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container passwordSignin() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: true,
        keyboardType: TextInputType.text,
        controller: passwordController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Container emailSignin() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Container namaSignup() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: namaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Container angkatanSignup() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: angkatanController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  //*

}

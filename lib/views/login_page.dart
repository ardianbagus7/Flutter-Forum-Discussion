import 'dart:async';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/utils/ClipPathHome.dart';
import 'package:discussion_app/utils/dropDownAngkatan.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:discussion_app/utils/validate.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String status;
  _LandingPageState({Key key, @required this.status});

  //*loading button
  bool isLoading = false;

  //* PAGE 1 (GET STARTED)
  double yHeightLandingFirst = 1000;
  double yHeightLanding;
  double yOffsetButton = 0;

  //* PAGE SIGNIN / SIGNUP
  int signin = 2;
  int signup = 2;

  //* NAVIGASI
  bool navigasiLanding = true;
  bool navigasiGetStarted = false;

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
  TextEditingController phoneController = TextEditingController();
  //* VALIDATOR
  String name;
  String email;
  String nomer;
  String password;
  String passwordConfirm;
  String message = '';
  String angkatan;
  bool statusAngkatan = false;

  //* SIGN IN
  void getSignin() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<AuthProvider>(context, listen: false).signin(emailController.text, passwordController.text);
    setState(() {
      isLoading = false;
    });
  }

  //* SIGN UP
  void getSignup() async {
    final form = _formKey.currentState;
    if (form.validate() && angkatan != null) {
      setState(() {
        statusAngkatan = false;
        isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false).signup(email: email, nomer: '62$nomer', nama: name, angkatan: angkatan, password: password);
      setState(() {
        isLoading = false;
      });
      print('oke');
    } else if (angkatan == null) {
      setState(() {
        statusAngkatan = true;
      });
    } else {
      setState(() {
        statusAngkatan = false;
      });
    }
    /* setState(() {
       
      });
    */
  }

  //* INIT STATE
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        navigasiGetStarted = true;
        yHeightLandingFirst = MediaQuery.of(context).size.height * 13 / 16;
      });
    });
  }

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
                      height: (!navigasiLanding) ? yHeightLanding : yHeightLandingFirst,
                      color: AppStyle.colorMain,
                    ),
                  ),

                  //*Button get started

                  (!navigasiGetStarted)
                      ? SizedBox()
                      : FadeInUp(
                          1.5,
                          Center(
                            child: AnimatedContainer(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 14 / 16),
                              duration: Duration(milliseconds: 500),
                              height: 50,
                              width: 250,
                              curve: Curves.easeInOut,
                              transform: Matrix4.translationValues(0, yOffsetButton, 0),
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
                                    navigasiGetStarted = false;
                                    navigasiLanding = !navigasiLanding;
                                    landing();
                                  });
                                },
                                child: Center(
                                  child: Text('Get started', style: AppStyle.textBody1),
                                ),
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
                            (signin == 1) ? FadeInUp(1.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Email', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                            (signin == 1) ? FadeInUp(2, emailSignin()) : SizedBox(),
                            (signin == 1) ? FadeInUp(2.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Password', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                            (signin == 1) ? FadeInUp(2.5, passwordSignin()) : SizedBox(),
                            SizedBox(height: 10),
                            (signin == 1) ? FadeInUp(3, signinButton()) : SizedBox(),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              (signup == 1) ? FadeInUp(1.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Nama', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                              (signup == 1) ? FadeInUp(2, namaSignup()) : SizedBox(),
                              (signup == 1) ? FadeInUp(2.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Angkatan', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                              (signup == 1)
                                  ? FadeInUp(
                                      3,
                                      angkatanDropDown(context),
                                    )
                                  : SizedBox(),
                              (statusAngkatan) ? Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Tahun angkatan tidak boleh kosong', style: TextStyle(color: Colors.red, fontSize: 12))) : SizedBox(),
                              (signup == 1) ? FadeInUp(3.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Nomor Telepon', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                              (signup == 1)
                                  ? FadeInUp(
                                      4,
                                      phoneSignup(),
                                    )
                                  : SizedBox(),
                              (signup == 1) ? FadeInUp(4.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Email', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                              (signup == 1) ? FadeInUp(5, emailSignup()) : SizedBox(),
                              (signup == 1) ? FadeInUp(5.5, Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0), child: Text('Password', style: AppStyle.textSubHeadingAbu))) : SizedBox(),
                              (signup == 1) ? FadeInUp(6, passwordSignup()) : SizedBox(),
                              SizedBox(height: 10),
                              (signup == 1) ? FadeInUp(6.5, signupButton()) : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  angkatanDropDown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppStyle.colorBg,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ), //
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      (angkatan == null)
                          ? Text(
                              'Pilih tahun angkatan..',
                              style: AppStyle.textCaption2grey,
                            )
                          : Text(
                              angkatan,
                              style: AppStyle.textCaption2,
                            ),
                      Icon(Icons.keyboard_arrow_down, color: AppStyle.colorMain)
                    ],
                  )),
            )),
        onTap: () async {
          String _angkatan = await Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) => DropDownAngkatan(),
            ),
          );
          setState(() {
            angkatan = _angkatan;
          });
        },
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
                    child: Center(child: Text('Masuk', style: AppStyle.textSubHeading2Putih)),
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
            builder: (context, provider, child) => provider.notification ?? NotificationText(''),
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
                phoneController = TextEditingController(text: '');
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Belum punya akun? ', style: AppStyle.textCaption2tipis),
                Text('Daftar sekarang', style: AppStyle.textCaption2),
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
                      child: Text('Daftar', style: AppStyle.textSubHeading2Putih),
                    ),
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
            builder: (context, provider, child) => provider.notification ?? NotificationText(''),
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
                phoneController = TextEditingController(text: '');
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('Sudah punya akun? ', style: AppStyle.textCaption2tipis), Text('Masuk sekarang', style: AppStyle.textCaption2)],
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Container emailSignup() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        // controller: emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
        ),
        validator: (value) {
          email = value.trim();
          return Validate.validateEmail(value);
        },
      ),
    );
  }

  Container passwordSignup() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        controller: passwordController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
        ),
        validator: (value) {
          password = value.trim();
          return Validate.passwordField(value);
        },
      ),
    );
  }

  Container namaSignup() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        //controller: namaController,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppStyle.colorBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
        ),
        validator: (value) {
          name = value.trim();
          return Validate.requiredField(value, 'Nama tidak boleh kosong');
        },
      ),
    );
  }

  Stack phoneSignup() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.number,
            //controller: phoneController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 55, top: 20, bottom: 20, right: 20),
              isDense: true,
              filled: true,
              fillColor: AppStyle.colorBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
            ),
            validator: (value) {
              nomer = value.trim();
              return Validate.nomerField(value);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 26),
          child: Text('+62', style: AppStyle.textSubHeadingAbu),
        )
      ],
    );
  }

  //*

}

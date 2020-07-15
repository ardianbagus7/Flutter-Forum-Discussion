import 'package:discussion_app/utils/animation/fade.dart';
import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';

class DropDownAngkatan extends StatefulWidget {
  @override
  _DropDownAngkatanState createState() => _DropDownAngkatanState();
}

class _DropDownAngkatanState extends State<DropDownAngkatan> {
  String angkatan;
  List<String> listTahun = [
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: SlideUp(
        0.5,
        Scaffold(
          backgroundColor: Colors.white.withOpacity(0.0),
          body: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 5 / 16,
                decoration: BoxDecoration(
                  color: AppStyle.colorWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0.0, -1),
                      blurRadius: 15.0,
                    )
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: listTahun.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              angkatan = listTahun[index];
                            });
                            Navigator.pop(context, angkatan);
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text('${listTahun[index]}', style: AppStyle.textSubHeadingAbu),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                child: Divider(
                                  thickness: 2,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

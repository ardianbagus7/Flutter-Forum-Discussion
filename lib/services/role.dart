import 'package:discussion_app/utils/style/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:discussion_app/utils/bubble.dart';

class Role {
  static int _developer = 6;
  static int _admin = 5;
  static int _dosen = 4;
  static int _alumni = 3;

  static List _roleName = ['Guest', 'Mahasiswa Aktif', 'Fungsionaris', 'Alumni', 'Dosen', 'Admin', 'Developer'];

  static int get developer => _developer;
  static int get admin => _admin;
  static int get alumni => _alumni;
  static int get dosen => _dosen;
  static List get roleName => _roleName;
}

Widget roleView(BuildContext context, int role) {
  switch (role) {
    case 0:
      return roleBubble(Role.roleName[0]);
    case 1:
      return roleBubble(Role.roleName[1]);
    case 2:
      return roleBubble(Role.roleName[2]);
    case 3:
      return roleBubble(Role.roleName[3]);
    case 4:
      return roleBubble(Role.roleName[4]);
    case 5:
      return roleBubble(Role.roleName[5]);
    case 6:
      return roleBubble(Role.roleName[6]);
    default:
      return Container();
  }
}

Bubble roleBubble(String rolename) {
  return Bubble(
      margin: BubbleEdges.only(top: 10),
      elevation: 0,
      nip: BubbleNip.leftTop,
      color: Colors.blue,
      child: Text(
        "$rolename",
        style: AppStyle.textSubHeadlinePutih,
      ),
    );
}

// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
        this.msg,
        this.user,
        this.token,
    });

    final String msg;
    final User user;
    final String token;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        msg: json["msg"] == null ? null : json["msg"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"] == null ? null : json["token"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "user": user == null ? null : user.toJson(),
        "token": token == null ? null : token,
    };
}

class User {
    User({
        this.id,
        this.email,
        this.name,
        this.nomer,
        this.angkatan,
        this.nrp,
        this.image,
        this.role,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final String email;
    final String name;
    final int nomer;
    final String angkatan;
    final String nrp;
    final String image;
    final int role;
    final DateTime createdAt;
    final DateTime updatedAt;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
        nomer: json["nomer"] == null ? null : json["nomer"],
        angkatan: json["angkatan"] == null ? null : json["angkatan"],
        nrp: json["nrp"] == null ? null : json["nrp"],
        image: json["image"] == null ? null : json["image"],
        role: json["role"] == null ? null : json["role"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "email": email == null ? null : email,
        "name": name == null ? null : name,
        "nomer": nomer == null ? null : nomer,
        "angkatan": angkatan == null ? null : angkatan,
        "nrp": nrp == null ? null : nrp,
        "image": image == null ? null : image,
        "role": role == null ? null : role,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}

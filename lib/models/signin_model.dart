// To parse this JSON data, do
//
//     final signIn = signInFromJson(jsonString);

import 'dart:convert';

SignIn signInFromJson(String str) => SignIn.fromJson(json.decode(str));

String signInToJson(SignIn data) => json.encode(data.toJson());

class SignIn {
    SignIn({
        this.msg,
        this.user,
        this.token,
    });

    final String msg;
    final User user;
    final String token;

    factory SignIn.fromJson(Map<String, dynamic> json) => SignIn(
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
        this.email,
        this.name,
        this.nrp,
        this.angkatan,
        this.role,
        this.image,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    final String email;
    final String name;
    final String nrp;
    final String angkatan;
    final int role;
    final String image;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int id;

    factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
        nrp: json["nrp"] == null ? null : json["nrp"],
        angkatan: json["angkatan"] == null ? null : json["angkatan"],
        role: json["role"] == null ? null : json["role"],
        image: json["image"] == null ? null : json["image"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "name": name == null ? null : name,
        "nrp": nrp == null ? null : nrp,
        "angkatan": angkatan == null ? null : angkatan,
        "role": role == null ? null : role,
        "image": image == null ? null : image,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "id": id == null ? null : id,
    };
}

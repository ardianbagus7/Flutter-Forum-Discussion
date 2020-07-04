// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

UserDetail userDetailFromJson(String str) => UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
    UserDetail({
        this.msg,
        this.user,
        this.post,
    });

    final String msg;
    final User user;
    final List<Post> post;

    factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        msg: json["msg"] == null ? null : json["msg"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        post: json["post"] == null ? null : List<Post>.from(json["post"].map((x) => Post.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "user": user == null ? null : user.toJson(),
        "post": post == null ? null : List<dynamic>.from(post.map((x) => x.toJson())),
    };
}

class Post {
    Post({
        this.id,
        this.title,
        this.kategori,
        this.postImage,
        this.name,
        this.userImage,
        this.createdAt,
    });

    final int id;
    final String title;
    final String kategori;
    final String postImage;
    final String name;
    final String userImage;
    final DateTime createdAt;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        kategori: json["kategori"] == null ? null : json["kategori"],
        postImage: json["post_image"] == null ? null : json["post_image"],
        name: json["name"] == null ? null : json["name"],
        userImage: json["user_image"] == null ? null : json["user_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "kategori": kategori == null ? null : kategori,
        "post_image": postImage == null ? null : postImage,
        "name": name == null ? null : name,
        "user_image": userImage == null ? null : userImage,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    };
}

class User {
    User({
        this.id,
        this.name,
        this.nrp,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.angkatan,
        this.role,
    });

    final int id;
    final String name;
    final String nrp;
    final String image;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic angkatan;
    final int role;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        nrp: json["nrp"] == null ? null : json["nrp"],
        image: json["image"] == null ? null : json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        angkatan: json["angkatan"],
        role: json["role"] == null ? null : json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "nrp": nrp == null ? null : nrp,
        "image": image == null ? null : image,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "angkatan": angkatan,
        "role": role == null ? null : role,
    };
}

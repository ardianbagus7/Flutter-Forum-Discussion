// To parse this JSON data, do
//
//     final idPost = idPostFromJson(jsonString);

import 'dart:convert';

IdPost idPostFromJson(String str) => IdPost.fromJson(json.decode(str));

String idPostToJson(IdPost data) => json.encode(data.toJson());

class IdPost {
    IdPost({
        this.msg,
        this.post,
        this.komentar,
    });

    final String msg;
    final List<Post> post;
    final List<Komentar> komentar;

    factory IdPost.fromJson(Map<String, dynamic> json) => IdPost(
        msg: json["msg"] == null ? null : json["msg"],
        post: json["post"] == null ? null : List<Post>.from(json["post"].map((x) => Post.fromJson(x))),
        komentar: json["komentar"] == null ? null : List<Komentar>.from(json["komentar"].map((x) => Komentar.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "post": post == null ? null : List<dynamic>.from(post.map((x) => x.toJson())),
        "komentar": komentar == null ? null : List<dynamic>.from(komentar.map((x) => x.toJson())),
    };
}

class Komentar {
    Komentar({
        this.id,
        this.userId,
        this.image,
        this.name,
        this.nrp,
        this.komentar,
        this.createdAt,
    });

    final int id;
    final int userId;
    final String image;
    final String name;
    final int nrp;
    final String komentar;
    final DateTime createdAt;

    factory Komentar.fromJson(Map<String, dynamic> json) => Komentar(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        image: json["image"] == null ? null : json["image"],
        name: json["name"] == null ? null : json["name"],
        nrp: json["nrp"] == null ? null : json["nrp"],
        komentar: json["komentar"] == null ? null : json["komentar"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "image": image == null ? null : image,
        "name": name == null ? null : name,
        "nrp": nrp == null ? null : nrp,
        "komentar": komentar == null ? null : komentar,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    };
}

class Post {
    Post({
        this.id,
        this.title,
        this.kategori,
        this.description,
        this.postImage,
        this.userId,
        this.name,
        this.userImage,
        this.createdAt,
    });

    final int id;
    final String title;
    final String kategori;
    final String description;
    final String postImage;
    final int userId;
    final String name;
    final String userImage;
    final DateTime createdAt;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        kategori: json["kategori"] == null ? null : json["kategori"],
        description: json["description"] == null ? null : json["description"],
        postImage: json["post_image"] == null ? null : json["post_image"],
        userId: json["userId"] == null ? null : json["userId"],
        name: json["name"] == null ? null : json["name"],
        userImage: json["user_image"] == null ? null : json["user_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "kategori": kategori == null ? null : kategori,
        "description": description == null ? null : description,
        "post_image": postImage == null ? null : postImage,
        "userId": userId == null ? null : userId,
        "name": name == null ? null : name,
        "user_image": userImage == null ? null : userImage,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    };
}

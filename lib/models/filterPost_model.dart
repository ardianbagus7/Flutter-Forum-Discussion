// To parse this JSON data, do
//
//     final filterPost = filterPostFromJson(jsonString);

import 'dart:convert';

FilterPost filterPostFromJson(String str) => FilterPost.fromJson(json.decode(str));

String filterPostToJson(FilterPost data) => json.encode(data.toJson());

class FilterPost {
    FilterPost({
        this.msg,
        this.posts,
    });

    final String msg;
    final List<Post> posts;

    factory FilterPost.fromJson(Map<String, dynamic> json) => FilterPost(
        msg: json["msg"] == null ? null : json["msg"],
        posts: json["posts"] == null ? null : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "posts": posts == null ? null : List<dynamic>.from(posts.map((x) => x.toJson())),
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

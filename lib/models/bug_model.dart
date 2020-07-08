// To parse this JSON data, do
//
//     final bug = bugFromJson(jsonString);

import 'dart:convert';

Bug bugFromJson(String str) => Bug.fromJson(json.decode(str));

String bugToJson(Bug data) => json.encode(data.toJson());

class Bug {
    Bug({
        this.posts,
    });

    final Posts posts;

    factory Bug.fromJson(Map<String, dynamic> json) => Bug(
        posts: json["posts"] == null ? null : Posts.fromJson(json["posts"]),
    );

    Map<String, dynamic> toJson() => {
        "posts": posts == null ? null : posts.toJson(),
    };
}

class Posts {
    Posts({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
    });

    final int currentPage;
    final List<DatumBug> data;
    final String firstPageUrl;
    final int from;
    final String nextPageUrl;
    final String path;
    final int perPage;
    final String prevPageUrl;
    final int to;

    factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<DatumBug>.from(json["data"].map((x) => DatumBug.fromJson(x))),
        firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        nextPageUrl: json["next_page_url"] == null ? null : json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from == null ? null : from,
        "next_page_url": nextPageUrl == null ? null : nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
    };
}

class DatumBug {
    DatumBug({
        this.id,
        this.deskripsi,
        this.bugImage,
        this.userId,
        this.name,
        this.userImage,
        this.createdAt,
    });

    final int id;
    final String deskripsi;
    final String bugImage;
    final int userId;
    final String name;
    final String userImage;
    final DateTime createdAt;

    factory DatumBug.fromJson(Map<String, dynamic> json) => DatumBug(
        id: json["id"] == null ? null : json["id"],
        deskripsi: json["deskripsi"] == null ? null : json["deskripsi"],
        bugImage: json["bug_image"] == null ? null : json["bug_image"],
        userId: json["userId"] == null ? null : json["userId"],
        name: json["name"] == null ? null : json["name"],
        userImage: json["user_image"] == null ? null : json["user_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "deskripsi": deskripsi == null ? null : deskripsi,
        "bug_image": bugImage == null ? null : bugImage,
        "userId": userId == null ? null : userId,
        "name": name == null ? null : name,
        "user_image": userImage == null ? null : userImage,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    };
}

// To parse this JSON data, do
//
//     final notif = notifFromJson(jsonString);

import 'dart:convert';

Notif notifFromJson(String str) => Notif.fromJson(json.decode(str));

String notifToJson(Notif data) => json.encode(data.toJson());

class Notif {
    Notif({
        this.total,
        this.notif,
    });

    final int total;
    final NotifClass notif;

    factory Notif.fromJson(Map<String, dynamic> json) => Notif(
        total: json["total"] == null ? null : json["total"],
        notif: json["notif"] == null ? null : NotifClass.fromJson(json["notif"]),
    );

    Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "notif": notif == null ? null : notif.toJson(),
    };
}

class NotifClass {
    NotifClass({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    final int currentPage;
    final List<DatumNotif> data;
    final String firstPageUrl;
    final int from;
    final int lastPage;
    final String lastPageUrl;
    final String nextPageUrl;
    final String path;
    final int perPage;
    final dynamic prevPageUrl;
    final int to;
    final int total;

    factory NotifClass.fromJson(Map<String, dynamic> json) => NotifClass(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<DatumNotif>.from(json["data"].map((x) => DatumNotif.fromJson(x))),
        firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"] == null ? null : json["last_page"],
        lastPageUrl: json["last_page_url"] == null ? null : json["last_page_url"],
        nextPageUrl: json["next_page_url"] == null ? null : json["next_page_url"],
        path: json["path"] == null ? null : json["path"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"] == null ? null : json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage == null ? null : currentPage,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl == null ? null : firstPageUrl,
        "from": from == null ? null : from,
        "last_page": lastPage == null ? null : lastPage,
        "last_page_url": lastPageUrl == null ? null : lastPageUrl,
        "next_page_url": nextPageUrl == null ? null : nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
        "total": total == null ? null : total,
    };
}

class DatumNotif {
    DatumNotif({
        this.id,
        this.userId,
        this.postId,
        this.imagePost,
        this.userPesanId,
        this.image,
        this.pesan,
        this.read,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final int userId;
    final int postId;
    final String imagePost;
    final int userPesanId;
    final String image;
    final String pesan;
    final int read;
    final DateTime createdAt;
    final DateTime updatedAt;

    factory DatumNotif.fromJson(Map<String, dynamic> json) => DatumNotif(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        postId: json["post_id"] == null ? null : json["post_id"],
        imagePost: json["imagePost"] == null ? null : json["imagePost"],
        userPesanId: json["user_pesan_id"] == null ? null : json["user_pesan_id"],
        image: json["image"] == null ? null : json["image"],
        pesan: json["pesan"] == null ? null : json["pesan"],
        read: json["read"] == null ? null : json["read"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "post_id": postId == null ? null : postId,
        "imagePost": imagePost == null ? null : imagePost,
        "user_pesan_id": userPesanId == null ? null : userPesanId,
        "image": image == null ? null : image,
        "pesan": pesan == null ? null : pesan,
        "read": read == null ? null : read,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}

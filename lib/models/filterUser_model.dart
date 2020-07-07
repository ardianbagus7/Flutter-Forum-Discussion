// To parse this JSON data, do
//
//     final filterUser = filterUserFromJson(jsonString);

import 'dart:convert';

FilterUser filterUserFromJson(String str) => FilterUser.fromJson(json.decode(str));

String filterUserToJson(FilterUser data) => json.encode(data.toJson());

class FilterUser {
    FilterUser({
        this.admin,
    });

    final Admin admin;

    factory FilterUser.fromJson(Map<String, dynamic> json) => FilterUser(
        admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
    );

    Map<String, dynamic> toJson() => {
        "admin": admin == null ? null : admin.toJson(),
    };
}

class Admin {
    Admin({
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
    final List<DatumFilterUser> data;
    final String firstPageUrl;
    final int from;
    final dynamic nextPageUrl;
    final String path;
    final int perPage;
    final String prevPageUrl;
    final int to;

    factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<DatumFilterUser>.from(json["data"].map((x) => DatumFilterUser.fromJson(x))),
        firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        nextPageUrl: json["next_page_url"],
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
        "next_page_url": nextPageUrl,
        "path": path == null ? null : path,
        "per_page": perPage == null ? null : perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
    };
}

class DatumFilterUser {
    DatumFilterUser({
        this.id,
        this.email,
        this.name,
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
    final String angkatan;
    final String nrp;
    final String image;
    final int role;
    final DateTime createdAt;
    final DateTime updatedAt;

    factory DatumFilterUser.fromJson(Map<String, dynamic> json) => DatumFilterUser(
        id: json["id"] == null ? null : json["id"],
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
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
        "angkatan": angkatan == null ? null : angkatan,
        "nrp": nrp == null ? null : nrp,
        "image": image == null ? null : image,
        "role": role == null ? null : role,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}

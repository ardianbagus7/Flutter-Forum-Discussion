// To parse this JSON data, do
//
//     final searchUser = searchUserFromJson(jsonString);

import 'dart:convert';

SearchUser searchUserFromJson(String str) => SearchUser.fromJson(json.decode(str));

String searchUserToJson(SearchUser data) => json.encode(data.toJson());

class SearchUser {
    SearchUser({
        this.admin,
    });

    final List<DatumSearch> admin;

    factory SearchUser.fromJson(Map<String, dynamic> json) => SearchUser(
        admin: json["admin"] == null ? null : List<DatumSearch>.from(json["admin"].map((x) => DatumSearch.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "admin": admin == null ? null : List<dynamic>.from(admin.map((x) => x.toJson())),
    };
}

class DatumSearch {
    DatumSearch({
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

    factory DatumSearch.fromJson(Map<String, dynamic> json) => DatumSearch(
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

// To parse this JSON data, do
//
//     final form = formFromJson(jsonString);

import 'dart:convert';

Form formFromJson(String str) => Form.fromJson(json.decode(str));

String formToJson(Form data) => json.encode(data.toJson());

class Form {
    Form({
        this.form,
    });

    final FormClass form;

    factory Form.fromJson(Map<String, dynamic> json) => Form(
        form: json["form"] == null ? null : FormClass.fromJson(json["form"]),
    );

    Map<String, dynamic> toJson() => {
        "form": form == null ? null : form.toJson(),
    };
}

class FormClass {
    FormClass({
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
    final List<DatumForm> data;
    final String firstPageUrl;
    final int from;
    final String nextPageUrl;
    final String path;
    final int perPage;
    final String prevPageUrl;
    final int to;

    factory FormClass.fromJson(Map<String, dynamic> json) => FormClass(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: json["data"] == null ? null : List<DatumForm>.from(json["data"].map((x) => DatumForm.fromJson(x))),
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

class DatumForm {
    DatumForm({
        this.id,
        this.verifImage,
        this.userId,
        this.name,
        this.email,
        this.role,
        this.nrp,
        this.userImage,
        this.createdAt,
    });

    final int id;
    final String verifImage;
    final int userId;
    final String name;
    final String email;
    final int role;
    final String nrp;
    final String userImage;
    final DateTime createdAt;

    factory DatumForm.fromJson(Map<String, dynamic> json) => DatumForm(
        id: json["id"] == null ? null : json["id"],
        verifImage: json["verif_image"] == null ? null : json["verif_image"],
        userId: json["userId"] == null ? null : json["userId"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        role: json["role"] == null ? null : json["role"],
        nrp: json["nrp"] == null ? null : json["nrp"],
        userImage: json["user_image"] == null ? null : json["user_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "verif_image": verifImage == null ? null : verifImage,
        "userId": userId == null ? null : userId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "role": role == null ? null : role,
        "nrp": nrp == null ? null : nrp,
        "user_image": userImage == null ? null : userImage,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    };
}

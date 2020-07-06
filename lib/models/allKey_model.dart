
import 'dart:convert';

AllKey allKeyFromJson(String str) => AllKey.fromJson(json.decode(str));

String allKeyToJson(AllKey data) => json.encode(data.toJson());

class AllKey {
    AllKey({
        this.msg,
        this.key,
    });

    final String msg;
    final List<Key> key;

    factory AllKey.fromJson(Map<String, dynamic> json) => AllKey(
        msg: json["msg"] == null ? null : json["msg"],
        key: json["key"] == null ? null : List<Key>.from(json["key"].map((x) => Key.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "key": key == null ? null : List<dynamic>.from(key.map((x) => x.toJson())),
    };
}

class Key {
    Key({
        this.key,
    });

    final String key;

    factory Key.fromJson(Map<String, dynamic> json) => Key(
        key: json["key"] == null ? null : json["key"],
    );

    Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
    };
}
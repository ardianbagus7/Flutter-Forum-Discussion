import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:discussion_app/models/allPost_model.dart';
import 'package:discussion_app/models/detailProfil_model.dart';
import 'package:discussion_app/models/filterPost_model.dart';
import 'package:discussion_app/models/idPost_model.dart';
import 'package:discussion_app/models/searchPost_model.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/utils/exceptions.dart';
import 'package:http/http.dart' as http;

class ApiService {
  AuthProvider authProvider;
  String token;
  String storageToken;
  String storageNama;

  ApiService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
    _init();
  }

  Future _init() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storageToken = storage.getString('token');
    storageNama = storage.getString('name');
  }

  final String api = 'http://192.168.43.47/api/v1';

  void validateResponseStatus(int status, int validStatus) {
    if (status == 401) {
      throw new AuthException("401", "Unauthorized");
    }

    if (status != validStatus) {
      throw new ApiException(status.toString(), 'Server down');
    }
  }

  Future<AllPost> getAllPost() async {
    final url = "$api/post";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    validateResponseStatus(response.statusCode, 200);

    print('token api : $token');
    print('token storage : $storageToken');

    return allPostFromJson(response.body);
  }

  Future<IdPost> getIdPost(int id, String tokenProvider) async {
    final url = "$api/post/$id";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenProvider'
    };

    final response = await http.get(url, headers: headers);
    print(response.body);
    validateResponseStatus(response.statusCode, 200);
    print('sukses get id post');
    return idPostFromJson(response.body);
  }

  Future<bool> createPost(String title, String description, String kategori,
      File image, String tokenProvider) async {
    final url = '$api/post';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['kategori'] = kategori;

    if (image != null) {
      var pic = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(pic);
    } else {}
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $tokenProvider';

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    validateResponseStatus(response.statusCode, 201);

    return true;
  }

  Future<bool> editPost(int id, String title, String description,
      String kategori, File image, String tokenProvider) async {
    final url = '$api/post/$id';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['_method'] = 'PATCH';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['kategori'] = kategori;

    if (image != null) {
      var pic = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(pic);
    } else {}
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $tokenProvider';

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    validateResponseStatus(response.statusCode, 200);

    return true;
  }

  Future<bool> deletePost(int id, String tokenNew, int role) async {
    final url = '$api/post/$id';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenNew'
    };

    Map<String, String> body = {'_method': 'DELETE', 'role': '$role'};

    final response = await http.post(url, headers: headers, body: body);

    validateResponseStatus(response.statusCode, 200);

    return true;
  }

  Future<FilterPost> filterPost(String kategori) async {
    final url = '$api/post/filter';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map<String, String> body = {
      'kategori': '$kategori',
    };

    final response = await http.post(url, headers: headers, body: body);

    validateResponseStatus(response.statusCode, 200);

    return filterPostFromJson(response.body);
  }

  Future<SearchPost> searchPost(String title) async {
    final url = '$api/post/search';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map<String, String> body = {
      'title': '$title',
    };

    final response = await http.post(url, headers: headers, body: body);

    validateResponseStatus(response.statusCode, 200);

    return searchPostFromJson(response.body);
  }

  //* KOMENTAR

  Future<bool> createKomentar(
      String postId, String komentar, String tokenProvider) async {
    final url = '$api/komentar';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenProvider'
    };

    Map<String, String> body = {
      'post_id': postId,
      'komentar': komentar,
    };

    final response = await http.post(url, headers: headers, body: body);

    validateResponseStatus(response.statusCode, 201);
    print('token api komentar : $tokenProvider');
    return true;
  }

  Future<bool> deleteKomentar(int id, String tokenNew, int role) async {
    final url = '$api/komentar/$id';
    print(url);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenNew'
    };

    Map<String, String> body = {'_method': 'DELETE', 'role': '$role'};

    final response = await http.post(url, headers: headers, body: body);
    print(response.body);
    validateResponseStatus(response.statusCode, 200);

    return true;
  }

  //* PROFIL

  Future<UserDetail> getDetailProfil() async {
    final url = "$api/user/detail";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    validateResponseStatus(response.statusCode, 200);

    print('token api detail profil : $token');

    return userDetailFromJson(response.body);
  }

  Future<bool> editProfil(
      String nama, String angkatan, File image, String tokenNew) async {
    final url = '$api/user/profil';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['name'] = nama;
    request.fields['angkatan'] = angkatan;

    if (image != null) {
      var pic = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(pic);
    } else {}

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $tokenNew';

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    validateResponseStatus(response.statusCode, 200);

    return true;
  }

  Future<bool> logout() async {
    final url = "$api/user/logout";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    validateResponseStatus(response.statusCode, 200);

    print('token api detail profil : $token');

    return true;
  }

  //* VERIFIKASI
  Future<int> cekVerifikasi(String key) async {
    final url = '$api/user/verifikasi/cek';

    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    Map<String, String> body = {
      'key': '$key',
    };

    final response = await http.post(url, headers: headers, body: body);

    return response.statusCode;
  }

  Future<int> verifikasi(
      String key, int role, String nrp, String tokenNew) async {
    final url = '$api/user/verifikasi';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenNew'
    };

    Map<String, String> body = {
      'role': '$role',
      'nrp': '$nrp',
      'key': '$key',
    };

    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    return response.statusCode;
  }
}

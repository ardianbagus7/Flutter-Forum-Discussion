import 'dart:io';

import 'package:discussion_app/models/allPost_model.dart';
import 'package:discussion_app/models/filterPost_model.dart';
import 'package:discussion_app/models/idPost_model.dart';
import 'package:discussion_app/models/searchPost_model.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/utils/exceptions.dart';
import 'package:http/http.dart' as http;

class ApiService {
  AuthProvider authProvider;
  String token;

  ApiService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
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

    return allPostFromJson(response.body);
  }

  Future<IdPost> getIdPost(int id) async {
    final url = "$api/post/$id";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    validateResponseStatus(response.statusCode, 200);

    return idPostFromJson(response.body);
  }

  Future<bool> createPost(
      String title, String description, String kategori, File image) async {
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
    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    validateResponseStatus(response.statusCode, 201);

    return true;
  }

  Future<bool> deletePost(int id) async {
    final url = '$api/post/$id';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map<String, String> body = {
      '_method': 'DELETE',
    };

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

  Future<bool> createKomentar(String postId, String komentar) async {
    final url = '$api/komentar';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map<String, String> body = {
      'post_id': postId,
      'komentar': komentar,
    };

    final response = await http.post(url, headers: headers, body: body);

    validateResponseStatus(response.statusCode, 201);

    return true;
  }
}

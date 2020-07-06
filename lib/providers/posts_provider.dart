import 'dart:io';

import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/services/api.dart';
import 'package:discussion_app/utils/exceptions.dart';
import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  bool _initialized = false;
  bool isLoading = false;
  // VARIABEL HASIL
  var allPost;
  var idPost;
  var filterPost;
  var searchPost;
  var detailProfil;
  //* ADMIN

  String statusCreate = 'menunggu';
  String statusDelete = 'menunggu';
  String statusKomentar = 'menunggu';
  String statusEditProfil = 'menunggu';
  String statusEditPost = 'menunggu';

  bool get initialized => _initialized;

  ApiService apiService;
  AuthProvider authProvider;

  PostProvider(AuthProvider authProvider) {
    this.apiService = ApiService(authProvider);
    this.authProvider = authProvider;
  }

  Future<bool> getAllPost() async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      isLoading = true;
      print('loading $isLoading');
      notifyListeners();
      final data = await apiService.getAllPost();
      allPost = data.posts;
      isLoading = false;
      print('loading $isLoading');
      notifyListeners();
      return true;
    } on AuthException {
      //Token expired, redirect login
      isLoading = false;
      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      isLoading = false;
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getIdPost(int id, String tokenProvider) async {
    try {
      idPost = null;
      isLoading = true;
      print('loading $isLoading');
      notifyListeners();
      final data = await apiService.getIdPost(id, tokenProvider);
      idPost = data;
      isLoading = false;
      print('loading $isLoading');
      notifyListeners();
      return true;
    } on AuthException {
      //Token expired, redirect login
      isLoading = false;
      print('loading $isLoading');
      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      isLoading = false;
      print('loading $isLoading');
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> createPost(String title, String description, String kategori,
      File image, String tokenProvider) async {
    try {
      statusCreate = 'loading';
      notifyListeners();
      final data = await apiService.createPost(
          title, description, kategori, image, tokenProvider);
      if (data) {
        statusCreate = 'sukses';
      }
      statusCreate = 'menunggu';

      print('sukses create post');
      notifyListeners();
      return true;
    } on AuthException {
      statusCreate = 'menunggu';
      notifyListeners();
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      statusCreate = 'menunggu';
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> editPost(int id, String title, String description,
      String kategori, File image, String tokenProvider) async {
    try {
      statusEditPost = 'loading';
      notifyListeners();
      final data = await apiService.editPost(
          id, title, description, kategori, image, tokenProvider);
      if (data) {
        statusEditPost = 'sukses';
      }
      statusEditPost = 'menunggu';

      print('sukses edit post');
      notifyListeners();
      return true;
    } on AuthException {
      statusEditPost = 'menunggu';
      notifyListeners();
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      statusEditPost = 'menunggu';
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> deletePost(int id, String token, int role) async {
    try {
      statusDelete = 'loading';
      notifyListeners();
      final data = await apiService.deletePost(id, token, role);
      if (data) {
        statusDelete = 'sukses';
      }
      print('delete sukses');
      notifyListeners();
      return true;
    } on AuthException {
      statusCreate = 'gagal';
      print('delete gagal');
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      statusCreate = 'gagal';
      print(exception);
      return false;
    }
  }

  Future<void> getFilterPost(String kategori) async {
    try {
      filterPost = null;
      notifyListeners();
      final data = await apiService.filterPost(kategori);
      filterPost = data.posts;

      print('sukses filter post');
      notifyListeners();
    } on AuthException {
      await authProvider.logOut(true);
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> getSearchPost(String title) async {
    try {
      searchPost = null;
      notifyListeners();
      final data = await apiService.searchPost(title);
      searchPost = data;
      print('sukses get search post');
      notifyListeners();
    } on AuthException {
      await authProvider.logOut(true);
    } catch (exception) {
      print(exception);
    }
  }

  //* KOMENTAR
  Future<bool> createKomentar(
      String postId, String komentar, String tokenProvider) async {
    try {
      statusKomentar = 'loading';
      notifyListeners();
      final data =
          await apiService.createKomentar(postId, komentar, tokenProvider);
      if (data) {
        statusKomentar = 'sukses';
      } else {
        statusKomentar = 'menunggu';
        notifyListeners();
      }
      return true;
    } on AuthException {
      statusKomentar = 'menunggu';
      notifyListeners();
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      statusKomentar = 'menunggu';
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> deleteKomentar(int id, String token, int role) async {
    try {
      statusDelete = 'loading';
      notifyListeners();
      final data = await apiService.deleteKomentar(id, token, role);
      if (data) {
        statusDelete = 'sukses';
      }
      notifyListeners();
      print('delete sukses');
      return true;
    } on AuthException {
      statusCreate = 'gagal';
      print('expired');
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      statusCreate = 'gagal';
      print(exception);
      return false;
    }
  }

  // PROFIL PROVIDER
  Future<void> getDetailProfil() async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      final data = await apiService.getDetailProfil();
      detailProfil = data;
      print('sukses get detail post');
      notifyListeners();
    } on AuthException {
      //Token expired, redirect login
      await authProvider.logOut(true);
    } catch (exception) {
      print(exception);
    }
  }

  Future<bool> editProfil(
      String nama, String angkatan, File image, String tokenNew) async {
    try {
      statusEditProfil = 'loading';
      notifyListeners();
      final data = await apiService.editProfil(nama, angkatan, image, tokenNew);
      if (data) {
        statusEditProfil = 'sukses';
      }
      statusEditProfil = 'menunggu';
      notifyListeners();
      return true;
    } on AuthException {
      statusEditProfil = 'menunggu';
      notifyListeners();
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      statusEditProfil = 'menunggu';
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<void> getLogout() async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      await apiService.logout();
      print('sukses logout');
      notifyListeners();
    } on AuthException {
      //Token expired, redirect login
      await authProvider.logOut(true);
    } catch (exception) {
      print(exception);
    }
  }

  //* CEK VERIFIKASI
  Future<String> getCekVerifikasi(String key) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      int _statuscek = await apiService.cekVerifikasi(key);
      if (_statuscek == 200) {
        return 'true';
      } else if (_statuscek == 204) {
        return 'false';
      }
      return 'false';
    } on AuthException {
      //Token expired, redirect login
      await authProvider.logOut(true);
      return 'gagal';
    } catch (exception) {
      print(exception);
      return 'gagal';
    }
  }

  Future<String> getVerifikasi(
      String key, int role, String nrp, String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      int _statuscek = await apiService.verifikasi(key, role, nrp, token);
      if (_statuscek == 200) {
        return 'true';
      } else if (_statuscek == 500) {
        return 'nrp';
      }
      return 'false';
    } on AuthException {
      //Token expired, redirect login
      await authProvider.logOut(true);
      return 'gagal';
    } catch (exception) {
      print(exception);
      return 'gagal';
    }
  }
}

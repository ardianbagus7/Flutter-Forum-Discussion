import 'package:discussion_app/models/allUser_model.dart';
import 'package:discussion_app/models/feedback_model.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:discussion_app/utils/exceptions.dart';
import 'package:discussion_app/models/filterUser_model.dart';
import 'package:discussion_app/models/searchUser_model.dart';

class AdminProvider with ChangeNotifier {
  bool isLoading = false;

  // VARIABEL HASIL
  var allKey;
  List<Datum> allUser = List<Datum>();
  List<DatumFeedback> allFeedback = List<DatumFeedback>();
  List<DatumFilterUser> allFilterUser = List<DatumFilterUser>();
  List<DatumSearch> allSearchUser = List<DatumSearch>();

  //List<Datum> allUser = List<Datum>();

  //* role
  List fixRole = [
    'Guest',
    'Mahasiswa Aktif',
    'Fungsionaris',
    'Alumni',
    'Dosen',
    'Admin',
    'Developer'
  ];

  //PAGINATION
  String nextPageUser;
  bool isLoadingMore;
  String nextPageFeedback;
  String nextPageFilterUser;

  //*
  ApiService apiService;
  AuthProvider authProvider;

  AdminProvider(AuthProvider authProvider) {
    this.apiService = ApiService(authProvider);
    this.authProvider = authProvider;
  }

  //* ADMIN PANEL

  Future<bool> getAllUser(String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      notifyListeners();
      final data = await apiService.getAllUser(token);
      print('data : ${data.user.data.length}');
      List<Datum> _listUser = data.user.data;
      allUser = _listUser;
      nextPageUser = data.user.nextPageUrl;
      notifyListeners();
      return true;
    } on AuthException {
      //Token expired, redirect login

      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getAllUserMore(String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      //pageAllUser++;
      String _url = nextPageUser;
      if (_url != null) {
        isLoadingMore = true;
        final data = await apiService.getAllUserMore(_url, token);

        print('data : ${data.user.data.length}');

        List<Datum> _listUser = data.user.data;
        List<Datum> _userSekarang = allUser;

        nextPageUser = data.user.nextPageUrl;

        List<Datum> _allUserNew = [..._userSekarang, ..._listUser];
        allUser = _allUserNew;

        isLoadingMore = false;
        notifyListeners();
        print('sukses tambah allUser more');
      } else {
        print('sudah habis gan');
      }
      return true;
    } on AuthException {
      //Token expired, redirect login
      isLoadingMore = false;
      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      isLoadingMore = false;
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getAllKey(String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      isLoading = true;
      notifyListeners();
      final data = await apiService.getAllKey(token);
      allKey = data.key;
      isLoading = false;
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

  Future<bool> generateKey(String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      isLoading = true;
      notifyListeners();
      await apiService.getGenerateKey(token);
      isLoading = false;
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

  Future<bool> getDeleteUser(String token, int id) async {
    try {
      //Jika tidak ada exceptions thrown dari API service

      bool _status = await apiService.deleteUser(id, token);
      if (_status) {
        return true;
      } else {
        return false;
      }
    } on AuthException {
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  Future<bool> getEditRole(int id, int role, String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service

      bool _status = await apiService.editAdminRole(id, role, token);
      if (_status) {
        return true;
      } else {
        return false;
      }
    } on AuthException {
      //Token expired, redirect login
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  //* FEEDBACK

  Future<bool> getAllFeedback(String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      notifyListeners();
      final data = await apiService.getAllFeedback(token);
      print('data : ${data.feedback.data.length}');
      List<DatumFeedback> _listFeedback = data.feedback.data;
      allFeedback = _listFeedback;
      nextPageFeedback = data.feedback.nextPageUrl;
      notifyListeners();
      return true;
    } on AuthException {
      //Token expired, redirect login

      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getAllFeedbackMore(String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      //pageAllUser++;
      String _url = nextPageFeedback;
      if (_url != null) {
        isLoadingMore = true;
        final data = await apiService.getAllFeedbackMore(_url, token);

        print('data : ${data.feedback.data.length}');

        List<DatumFeedback> _listFeedback = data.feedback.data;
        List<DatumFeedback> _feedbackSekarang = allFeedback;

        nextPageFeedback = data.feedback.nextPageUrl;

        List<DatumFeedback> _allFeedbackNew = [
          ..._feedbackSekarang,
          ..._listFeedback
        ];
        allFeedback = _allFeedbackNew;

        isLoadingMore = false;
        notifyListeners();
        print('sukses tambah allFeedback more');
      } else {
        print('sudah habis gan');
      }
      return true;
    } on AuthException {
      //Token expired, redirect login
      isLoadingMore = false;
      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      isLoadingMore = false;
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getAllFilterUser(int role, String token) async {
    try {
      allFilterUser = null;
      //Jika tidak ada exceptions thrown dari API service
      notifyListeners();
      final data = await apiService.filterUser(role, token);
      print('data : ${data.admin.data.length}');
      List<DatumFilterUser> _listUser = data.admin.data;
      allFilterUser = _listUser;
      nextPageFilterUser = data.admin.nextPageUrl;
      notifyListeners();
      return true;
    } on AuthException {
      //Token expired, redirect login

      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getAllFilterUserMore(int role, String token) async {
    try {
      //Jika tidak ada exceptions thrown dari API service
      //pageAllUser++;
      String _url = nextPageFilterUser;
      if (_url != null) {
        isLoadingMore = true;
        final data =
            await apiService.getAllFilterUserMore(role - 1, _url, token);

        print('data : ${data.admin.data.length}');

        List<DatumFilterUser> _listFilterUser = data.admin.data;
        List<DatumFilterUser> _filterUserSekarang = allFilterUser;

        nextPageFilterUser = data.admin.nextPageUrl;

        List<DatumFilterUser> _allFilterUserNew = [
          ..._filterUserSekarang,
          ..._listFilterUser
        ];
        allFilterUser = _allFilterUserNew;

        isLoadingMore = false;
        notifyListeners();
        print('sukses tambah allFilterUser more');
      } else {
        print('sudah habis gan');
      }
      return true;
    } on AuthException {
      //Token expired, redirect login
      isLoadingMore = false;
      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      isLoadingMore = false;
      notifyListeners();
      print(exception);
      return false;
    }
  }

  Future<bool> getSearchUser(String param, String token) async {
    try {
      allSearchUser = null;
      //Jika tidak ada exceptions thrown dari API service
      notifyListeners();
      final data = await apiService.searchUser(param, token);
      print('data : ${data.admin.length}');
      List<DatumSearch> _listUser = data.admin;
      allSearchUser = _listUser;

      notifyListeners();
      return true;
    } on AuthException {
      //Token expired, redirect login

      notifyListeners();
      await authProvider.logOut(true);
      return false;
    } catch (exception) {
      notifyListeners();
      print(exception);
      return false;
    }
  }
  //*
}

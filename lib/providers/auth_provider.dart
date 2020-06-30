import 'package:discussion_app/models/auth_model.dart';
import 'package:discussion_app/widgets/notification_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  String _token;
  String _name;
  String _profil;
  NotificationText _notification;

  Status get status => _status;
  String get token => _token;
  String get name => _name;
  String get profil => _profil;
  NotificationText get notification => _notification;

  // URL ENDPOINT API USER
  final String api = "http://192.168.43.47/api/v1/user";

  initAuthProvider() async {
    String token = await getToken();
    String name = await getName();
    String profil = await getProfil();
    if (token != null) {
      _token = token;
      _name = name;
      _profil = profil;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> signin(String nrp, String password) async {
    _status = Status.Authenticating;
    _notification = null;
    notifyListeners();

    final url = "$api/signin";

    Map<String, String> body = {
      'nrp': nrp,
      'password': password,
    };

    Map<String, String> headers = {'Accept': 'application/json'};
    print(_status);

    final response = await http.post(url, body: body, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var apiResponse = loginFromJson(response.body);
      _status = Status.Authenticated;
      _token = apiResponse.token;
      _name = apiResponse.user.name;
      _profil = apiResponse.user.image;
      await storeUserData(apiResponse);
      notifyListeners();
      return true;
    }

    if (response.statusCode == 404) {
      _status = Status.Unauthenticated;
      _notification = NotificationText('Nrp atau password salah');
      notifyListeners();
      return false;
    }

    _status = Status.Unauthenticated;
    _notification = NotificationText('Server sedang bermasalah.');
    notifyListeners();
    return false;
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', apiResponse.token);
    await storage.setString('name', apiResponse.user.name);
    await storage.setString('profil', apiResponse.user.image);
  }

  Future<String> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token');
    return token;
  }

  Future<String> getName() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String name = storage.getString('name');
    return name;
  }

  Future<String> getProfil() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String profil = storage.getString('profil');
    return profil;
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification =
          NotificationText('Waktu sesi habis. Harap masuk lagi.', type: 'info');
    }
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}

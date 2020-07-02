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
  String _angkatan;
  int _role;
  String _profil;
  String _nrp;
  String _password;
  NotificationText _notification;

  Status get status => _status;
  String get token => _token;
  String get name => _name;
  String get profil => _profil;
  int get role => _role;
  String get angkatan => _angkatan;

  NotificationText get notification => _notification;

  // URL ENDPOINT API USER
  final String api = "http://192.168.43.47/api/v1/user";

  initAuthProvider() async {
    String nrp = await getNrp();
    String password = await getPassword();
    String token = await getToken();
    String name = await getName();
    String profil = await getProfil();
    int role = await getRole();
    String angkatan = await getAngkatan();
    if (token != null) {
      _nrp = nrp;
      _password = password;
      _token = token;
      _name = name;
      _profil = profil;
      _role = role;
      _angkatan = angkatan;
      signin(_nrp, _password);
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
      _role = apiResponse.user.role;
      _angkatan = apiResponse.user.angkatan;
      await storeUserData(apiResponse, nrp, password);
      notifyListeners();

      print('login sukses');
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

  storeUserData(apiResponse, nrp, password) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('nrp', nrp);
    await storage.setString('password', password);
    await storage.setString('token', apiResponse.token);
    await storage.setString('name', apiResponse.user.name);
    await storage.setString('profil', apiResponse.user.image);
    await storage.setString('angkatan', apiResponse.user.angkatan);
    await storage.setInt('role', apiResponse.user.role);
  }

  Future<String> getNrp() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String nrp = storage.getString('nrp');
    return nrp;
  }

  Future<String> getPassword() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String password = storage.getString('password');
    return password;
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

  Future<int> getRole() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int role = storage.getInt('role');
    return role;
  }

  Future<String> getAngkatan() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String angkatan = storage.getString('angkatan');
    return angkatan;
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      signin(_nrp, _password);
      _notification =
          NotificationText('Waktu sesi habis. Harap masuk lagi.', type: 'info');
    } else {
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.clear();
    }
    notifyListeners();
  }

  Future reLogin() async {
    signin(_nrp, _password);
  }
}

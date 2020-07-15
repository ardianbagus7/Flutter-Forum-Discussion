import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/views/home_page.dart';
import 'package:discussion_app/views/loading.dart';
import 'package:discussion_app/views/login_page.dart';
import 'package:discussion_app/views/reLogin_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// BACKGROUND FETCH
const simplePeriodicTask = "simplePeriodicTask";
// LOCAL NOTIFICATION SETUP
void showNotification(v, flp) async {
  var android = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION', priority: Priority.High, importance: Importance.Max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android, iOS);
  await flp.show(0, 'Tune Apps', '$v', platform, payload: 'New notification \n $v');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: false); // DEBUG MODE
  await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15), // FREKUENSI FETCH API
      initialDelay: Duration(seconds: 5), // DURASI DELAY NOTIF
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
  runApp(
    ChangeNotifierProvider(create: (context) => AuthProvider(), child: MyApp()),
  );
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, iOS);
    flp.initialize(initSetttings);
    try {
      SharedPreferences storage = await SharedPreferences.getInstance();
      int idUser = storage.getInt('id');
      print('id user = $idUser');
      var response = await http.get('http://138.91.32.37/api/v1/notif/$idUser');
      print(response.body);
      var convert = json.decode(response.body);
      if (convert['read'] == 0) {
        showNotification(convert['pesan'], flp);
      } else {
        print("no messgae");
      }
    } catch (e) {
      print(e);
    }

    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostProvider(authProvider)),
        ChangeNotifierProvider(create: (context) => AdminProvider(authProvider)),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Router(),
          '/home-page': (context) => HomePage(),
        },
      ),
    );
  }
}

class Router extends StatefulWidget {
  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        switch (user.status) {
          case Status.Relogin:
            return Relogin();
          case Status.Uninitialized:
            return Loading();
          case Status.Unauthenticated:
            return LandingPage(status: user.status.toString());
          case Status.Authenticated:
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => PostProvider(authProvider)),
              ],
              child: HomePage(),
            );
          default:
            return LandingPage(status: user.status.toString());
        }
      },
    );
  }
}

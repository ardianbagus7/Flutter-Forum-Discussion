import 'package:discussion_app/providers/admin_provider.dart';
import 'package:discussion_app/providers/auth_provider.dart';
import 'package:discussion_app/providers/posts_provider.dart';
import 'package:discussion_app/views/home_page.dart';
import 'package:discussion_app/views/loading.dart';
import 'package:discussion_app/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => AuthProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostProvider(authProvider)),
        ChangeNotifierProvider(
            create: (context) => AdminProvider(authProvider)),
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
          case Status.Uninitialized:
            return Loading();
          case Status.Unauthenticated:
            return LandingPage(status: user.status.toString());
          case Status.Authenticated:
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (context) => PostProvider(authProvider)),
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

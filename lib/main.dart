import 'package:app_route_map/pages/home_page.dart';
import 'package:app_route_map/pages/login_page.dart';
import 'package:app_route_map/preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreference.init();
  await dotenv.load();
  runApp(const AppRouteMap());
}

class AppRouteMap extends StatelessWidget {
  const AppRouteMap({super.key});

  @override
  Widget build(BuildContext context) {
    var token = UserPreference.getString('token');
    return Provider(
      create: (context) => AppRouteMapState(),
      child: MaterialApp(
          title: 'App Route Map',
          initialRoute: token == null ? 'login' : '/',
          routes: {
            '/': (context) => const HomePage(),
            'login': (context) => const LoginPage(),
          },
          debugShowCheckedModeBanner: false),
    );
  }
}

class AppRouteMapState extends ChangeNotifier {
  var test = '';
}

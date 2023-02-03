import 'package:app_route_map/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRouteMap());
}

class AppRouteMap extends StatelessWidget {
  const AppRouteMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppRouteMapState(),
      child: MaterialApp(
          title: 'App Route Map',
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginPage(),
          },
          debugShowCheckedModeBanner: false),
    );
  }
}

class AppRouteMapState extends ChangeNotifier {
  var test = '';
}

import 'package:app_route_map/preferences/user_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var truck = UserPreference.getString('truck');
    print(truck);
    return GFDrawer(
      child: ListView(
        children: [
          Center(
            child: GFDrawerHeader(
              currentAccountPicture: const GFAvatar(
                size: GFSize.LARGE,
                child: Icon(Icons.person_2),
              ),
              centerAlign: true,
              child: AutoSizeText(truck!),
            ),
          ),
          GFListTile(
            avatar: const Icon(FontAwesomeIcons.truck),
            title: const Text('Hojas de ruta'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          GFListTile(
            avatar: const Icon(Icons.logout),
            title: const Text('Cerrar Sesion'),
            onTap: () {
              UserPreference.clearSession();
              Navigator.pushNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }
}

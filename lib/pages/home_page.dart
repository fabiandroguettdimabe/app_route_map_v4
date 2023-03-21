import 'package:app_route_map/pages/details_page.dart';
import 'package:app_route_map/preferences/user_preferences.dart';
import 'package:app_route_map/services/map_service.dart';
import 'package:app_route_map/widgets/app_bar_widget.dart';
import 'package:async_builder/async_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

import '../models/route_map_model.dart';
import '../widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<RouteMap>> maps;

  @override
  void initState() {
    maps = MapService().getRouteMaps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBarWidget(
            message: 'Bienvenido ${UserPreference.getString('partner_name')!}'),
      ),
      body: listMap(),
      drawer: const DrawerWidget(),
    );
  }

  Widget listMap() {
    return AsyncBuilder(
      future: MapService().getRouteMaps(),
      waiting: (context) => const GFLoader(),
      builder: (context, List<RouteMap>? value) {
        return ListView.separated(
          itemBuilder: (context, index) {
            return NextAccordion(
              title: GFListTile(
                avatar: const FaIcon(FontAwesomeIcons.truckFast, size: 17),
                title: AutoSizeText(value![index].name),
              ),
              children: [
                GFButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(id: value[index].id),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  child: const AutoSizeText('Detalle'),
                )
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: value != null ? value.length : 0,
        );
      },
    );
  }
}

void _showToast(BuildContext context, String? message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(message!),
    action:
        SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  ));
}

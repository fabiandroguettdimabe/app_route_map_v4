import 'package:app_route_map/services/map_service.dart';
import 'package:app_route_map/widgets/app_bar_widget.dart';
import 'package:app_route_map/widgets/drawer_widget.dart';
import 'package:async_builder/async_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

import '../models/route_map_model.dart';
import '../utils/color_util.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  TextEditingController observationsController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  List<String> files = [];
  int counterImages = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarWidget(message: 'Hoja de ruta')),
      body: details(context),
      drawer: const DrawerWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget details(BuildContext context) {
    return AsyncBuilder(
      future: MapService().getRouteMap(widget.id),
      waiting: (context) => const GFLoader(),
      error: (context, error, stackTrace) => const Center(
        child: AutoSizeText(
            'Error en comunicacion, por favor comuniquese con el administrador'),
      ),
      builder: (context, value) {
        return GFCard(
          boxFit: BoxFit.fill,
          elevation: 10.0,
          title: GFListTile(
            avatar: const Icon(FontAwesomeIcons.map),
            titleText: "Detalle de ${value!.name}",
            subTitleText: "Sello : ${value.sell}",
          ),
          content: listDelivery(context, value.lineIds),
        );
      },
    );
  }

  Widget listDelivery(BuildContext context, List<RouteMapLine> lines) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      width: size.width * 0.8,
      child: InfiniteList(
        scrollDirection: Axis.vertical,
        itemCount: lines.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return NextAccordion(
            trailing: (isExpanded) {
              switch (lines[index].state) {
                case 'to_delivered':
                  return isExpanded
                      ? const Icon(FontAwesomeIcons.caretUp)
                      : const Icon(FontAwesomeIcons.caretDown);
                case 'ok':
                  return const Icon(FontAwesomeIcons.checkDouble);
                case 'homeless':
                  return const Icon(FontAwesomeIcons.houseCircleXmark);
                case 'cancel':
                  return const Icon(FontAwesomeIcons.ban);
                case 'conveyor':
                  return const Icon(FontAwesomeIcons.truckFast);
              }
            },
            title: GFListTile(
              avatar: const Icon(FontAwesomeIcons.truckFront),
              title: AutoSizeText(lines[index].reference),
            ),
            textColor: getColorByState(lines[index].state),
            children: [
              GFListTile(
                avatar: const Icon(FontAwesomeIcons.mapLocationDot),
                subTitle: AutoSizeText(lines[index].address),
                title: const AutoSizeText('Dirección'),
              ),
              Visibility(
                  visible: lines[index].state == 'to_delivered',
                  child: buttonActions(lines[index])),
              Visibility(
                visible: lines[index].state != 'to_delivered',
                child: const AutoSizeText('Pedido Finalizado'),
              )
            ],
          );
        },
        onFetchData: () {
          print('Prueba');
        },
      ),
    );
  }

  Widget buttonActions(RouteMapLine line) {
    return GFButtonBar(children: [
      GFButton(
          color: getColorByName('blue'),
          onPressed: () {
            showMap(line.destinyGps);
          },
          icon: const Icon(FontAwesomeIcons.mapLocationDot,
              color: Colors.white, size: 17),
          text: 'GPS'),
      GFButton(
          color: getColorByName('green'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return alertDialog(line);
              },
            );
          },
          icon: const Icon(FontAwesomeIcons.checkDouble,
              color: Colors.white, size: 17),
          text: 'Finalizar')
    ]);
  }

  showMap(LatLng destiny) async {
    final availableMaps = await MapLauncher.installedMaps;
    if (availableMaps.isEmpty) {
      _showToast(context, "No cuenta con ninguna app de mapa");
    } else {
      print(availableMaps);
      availableMaps.first.showDirections(
          destination: Coords(destiny.latitude, destiny.longitude),
          directionsMode: DirectionsMode.driving);
    }
  }

  Widget alertDialog(RouteMapLine line) {
    List<String> paths = [];
    return AlertDialog(
        title: const Text("Finalizar entrega", textAlign: TextAlign.center),
        content: Wrap(
          children: [
            const Divider(),
            selectState(),
            const Divider(),
            TextField(
              controller: observationsController,
              decoration: const InputDecoration(
                hintText: 'Observaciones',
              ),
            ),
            const Divider(),
            GFButtonBadge(
              text: 'Seleccionar imagen',
              icon: GFBadge(child: AutoSizeText(paths.length.toString())),
              fullWidthButton: true,
              onPressed: () {
                imagePicker(paths).then((value) {
                  paths = value;
                  _incrementCounter();
                });
              },
              blockButton: true,
            ),
            const Divider(),
            GFButton(
              onPressed: () {
                MapService()
                    .makeDone(line.id, stateController.text, paths)
                    .then((value) {
                  if (value.containsKey('isComplete')) {
                    if (value['isComplete']) {
                      Navigator.pushNamed(context, '/');
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    }
                  }
                });
              },
              color: getColorByName('green'),
              blockButton: true,
              text: 'Finalizar',
            )
          ],
        ));
  }

  Widget selectState() {
    return AsyncBuilder(
      future: MapService().getState(),
      builder: (context, value) {
        return SmartSelect<String>.single(
          title: 'Seleccione estado de entrega',
          selectedValue: stateController.text,
          choiceItems: value,
          onChange: (value) {
            stateController.text = value.value;
          },
        );
      },
    );
  }

  Future<List<String>> imagePicker(List<String> paths) async {
    final ImagePicker picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        paths.add(image.path);
      }
      _incrementCounter();
      return paths;
    }
    return [];
  }

  void _incrementCounter() {
    setState(() {
      counterImages = files.length;
    });
  }
}

void _showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(message),
    action:
        SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  ));
}

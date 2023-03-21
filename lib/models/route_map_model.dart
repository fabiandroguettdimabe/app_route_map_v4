import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteMap {
  RouteMap({
    this.id = 0,
    this.name = '',
    this.sell = '',
    this.lineIds = const [],
  });

  int id;
  String name;
  String sell;
  List<RouteMapLine> lineIds;
}

class RouteMapLine {
  RouteMapLine({
    this.id = 0,
    this.address = '',
    this.reference = '',
    this.state = '',
    this.destinyGps = const LatLng(0.0, 0.0),
  });

  int id;
  String reference;
  String state;
  String address;
  LatLng destinyGps;
}

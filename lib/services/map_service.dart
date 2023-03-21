import 'dart:async';
import 'dart:convert';
import 'dart:io' as I_o;

import 'package:app_route_map/preferences/user_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/route_map_model.dart';

class MapService {
  Future<List<RouteMap>> getRouteMaps() async {
    final endpoint = "${dotenv.env['API_URL']}api/route_maps";
    final dio = Dio();
    final data = {"params": {}};
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["TOKEN"] = "${UserPreference.getString('token')}";
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    try {
      final response = await dio.post(endpoint, data: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data.keys.contains('result')) {
          List<RouteMap> maps = [];
          List<dynamic> result = data['result'];
          if (result.isNotEmpty) {
            for (var res in result) {
              var map = RouteMap();
              map.id = res['id'];
              map.name = res['display_name'];
              maps.add(map);
            }
          }
          return maps;
        }
      }
      return <RouteMap>[];
    } catch (e) {
      print(e);
      return <RouteMap>[];
    }
  }

  Future<RouteMap?> getRouteMap(int id) async {
    final endpoint = "${dotenv.env['API_URL']}api/route_map";
    final dio = Dio();
    final data = {
      "params": {"map_id": id}
    };
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["TOKEN"] = "${UserPreference.getString('token')}";
    final response = await dio.post(endpoint, data: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data.keys.contains('result')) {
        Map<String, dynamic> result = data['result'];
        var map = RouteMap();
        var lines = <RouteMapLine>[];
        map.id = result['id'];
        map.name = result['display_name'];
        for (var line in result['line_ids']) {
          var rLine = RouteMapLine();
          rLine.id = line['id'];
          rLine.reference = line['reference'] != false ? line['reference'] : '';
          rLine.destinyGps =
              LatLng(line['partner_latitude'], line['partner_longitude']);
          rLine.state = line['state'];
          rLine.address = line['address'] != false
              ? line['address']
              : 'Sin Direccion Especificada';
          lines.add(rLine);
        }
        map.lineIds = lines;
        return map;
      }
      return RouteMap();
    }
    return RouteMap();
  }

  Future<List<S2Choice<String>>> getState() async {
    final endpoint = "${dotenv.env['API_URL']}api/states";
    final dio = Dio();
    final data = {"params": {}};
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['TOKEN'] = "${UserPreference.getString('token')}";
    final response = await dio.post(endpoint, data: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      List<S2Choice<String>> states = [];
      if (data.keys.contains('result')) {
        var result = data['result'];
        for (var item in result) {
          states.add(S2Choice(value: item['value'], title: item['name']));
        }
        return states;
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> makeDone(
      int id, String state, List<String> filePaths) async {
    final endpoint = "${dotenv.env['API_URL']}api/done";
    LatLng position = const LatLng(0, 0);
    if (await requestLocationPermission()) {
      var geoLocator = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      position = LatLng(geoLocator.latitude, geoLocator.longitude);
    }
    final dio = Dio();
    final data = {
      "params": {
        "line_id": id,
        "state": state,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "files": getFileBase64(filePaths),
      }
    };
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["TOKEN"] = "${UserPreference.getString('token')}";
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    final response = await dio.post(endpoint, data: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data.keys.contains('is_complete')) {
        return {'isComplete': true};
      } else {
        return {'isComplete': false};
      }
    }
    return {'Error': true};
  }

  List<String> getFileBase64(List<String> filePaths) {
    if (filePaths.isNotEmpty) {
      List<String> listBase64 = [];
      for (var path in filePaths) {
        var file = I_o.File(path);
        List<int> imageBytes = file.readAsBytesSync();
        listBase64.add(base64Encode(imageBytes));
      }
      return listBase64;
    }
    return [];
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus result;
    result = await Permission.location.request();
    if (result.isGranted) {
      return true;
    }
    return false;
  }
}

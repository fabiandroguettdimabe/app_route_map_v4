import 'package:flutter/material.dart';

getColorByState(String state) {
  switch (state) {
    case 'ok':
      return const Color(0xff28a745);
    case 'parcial':
      return const Color(0xff17a2b8);
    default:
      return const Color(0xff17a2b8);
  }
}

getColorByName(String state) {
  switch (state) {
    case 'green':
      return const Color(0xff28a745);
    case 'blue':
      return const Color(0xff17a2b8);
    case 'red':
      return const Color(0xffc62828);
    default:
      return const Color.fromRGBO(255, 255, 255, 0);
  }
}

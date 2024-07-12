import 'dart:convert';
import 'dart:io';

import 'package:findooproveedor/commons/consts.dart';
import 'package:findooproveedor/models/solicitud.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SolicitudProvider extends ChangeNotifier {
  List<Solicitud> solicitudesRecibidas;
  List<Solicitud> solicitudesEnviadas;
  List<Solicitud> solicitudesPapelera;

  Future<List<Solicitud>> fetchSolicitudesRecibidas() async {
    try {
      print("aqui");
      print(SessionHelper().id.toString());
      final response = await http.get(
          (Constantes.url +
              "solicitudesProveedor/" +
              SessionHelper().id.toString() +
              "/0/"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "charset": "utf-8"
          });
      if (response.statusCode == 200) {
        List<dynamic> responseJson =
            json.decode(utf8.decode(response.bodyBytes));
        solicitudesRecibidas =
            responseJson.map((m) => new Solicitud.fromJson(m)).toList();
        notifyListeners();
        return solicitudesRecibidas;
      } else {
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  Future<List<Solicitud>> fetchSolicitudesEnviadas() async {
    try {
      final response = await http.get(
          (Constantes.url +
              "solicitudesProveedor/" +
              SessionHelper().id.toString() +
              "/1/"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "charset": "utf-8"
          });
      if (response.statusCode == 200) {
        List<dynamic> responseJson =
            json.decode(utf8.decode(response.bodyBytes));
        solicitudesEnviadas =
            responseJson.map((m) => new Solicitud.fromJson(m)).toList();
        notifyListeners();
        print("cargo");
        return solicitudesEnviadas;
      } else {
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  Future<List<Solicitud>> fetchSolicitudesPapelera() async {
    try {
      final response = await http.get(
          (Constantes.url +
              "solicitudesProveedor/" +
              SessionHelper().id.toString() +
              "/3/"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "charset": "utf-8"
          });
      if (response.statusCode == 200) {
        List<dynamic> responseJson =
            json.decode(utf8.decode(response.bodyBytes));
        solicitudesPapelera =
            responseJson.map((m) => new Solicitud.fromJson(m)).toList();
        notifyListeners();
        print("cargo");
        return solicitudesPapelera;
      } else {
        return null;
      }
    } on SocketException {
      return null;
    }
  }
}

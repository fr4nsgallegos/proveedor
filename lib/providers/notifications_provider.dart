import 'package:findooproveedor/utils/http_helper.dart';
import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  int cantidad = 0;

  Future fetchNotificaciones() async {
    HttpHelper helper = HttpHelper();
    cantidad = await helper.obtenerCantidadNotificaciones();
    notifyListeners();
  }
}

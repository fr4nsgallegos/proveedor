import 'package:findooproveedor/utils/session_helper.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int id = 0;
  String email;
  String first_name;
  String last_name;
  String imagen;
  String codigo_promocion;
  String rol;
  String fecha_vencimiento;
  int categorias;

  Future fetchUserData() async {
    SessionHelper session = SessionHelper();
    await session.fetchUserData();
    id = session.id;
    codigo_promocion = session.codigo_promocion;
    first_name = session.first_name;
    last_name = session.last_name;
    imagen = session.imagen;
    email = session.email;
    rol = session.rol;
    categorias = session.categorias;
    notifyListeners();
  }

  Future clearUserData() async {
    SessionHelper session = SessionHelper();
    await session.clearUserData();
    id = session.id;
    notifyListeners();
  }
}

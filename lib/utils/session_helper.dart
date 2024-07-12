import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  int id = 0;
  String email;
  String first_name;
  String last_name;
  String imagen;
  String codigo_promocion;
  String token;
  String rol;
  int plan;
  dynamic fecha_vencimiento;
  String empresa_logo;
  bool plancaducado = false;
  int categorias;

  static final SessionHelper _sessionHelper = SessionHelper._internal();

  SessionHelper._internal();

  factory SessionHelper() {
    return _sessionHelper;
  }

  Future fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id");
    codigo_promocion = prefs.getString("codigo_promocion");
    first_name = prefs.getString("first_name");
    last_name = prefs.getString("last_name");
    imagen = prefs.getString("imagen");
    email = prefs.getString("email");
    token = prefs.getString("token");
    rol = prefs.getString("rol");
    categorias = prefs.getInt("categorias");
  }

  Future clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = 0;
    prefs.setInt("id", id);
  }
}

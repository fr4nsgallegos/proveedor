import 'package:findooproveedor/models/ciudad.dart';
import 'package:findooproveedor/models/empresa.dart';
import 'package:findooproveedor/providers/user_provider.dart';
import 'package:findooproveedor/routes/contactanos_route.dart';
import 'package:findooproveedor/routes/lista_mensajes_route.dart';
import 'package:findooproveedor/routes/notificaciones_route.dart';
import 'package:findooproveedor/routes/perfil_screen.dart';
import 'package:findooproveedor/routes/registro_screen.dart';
import 'package:findooproveedor/routes/terminos_condiciones_route.dart';
import 'package:findooproveedor/routes/verificacion_vales_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FindooNavDrawer extends StatefulWidget {
  @override
  _FindooNavDrawerState createState() => _FindooNavDrawerState();
}

class _FindooNavDrawerState extends State<FindooNavDrawer> {
  List<Ciudad> ciudades;
  Empresa _empresa;
  Future cargarCiudades() async {
    ciudades = await HttpHelper().getCiudades();
    setState(() {
      ciudades = ciudades;
    });
  }

  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Widget _buildFoto(BuildContext context) {
    if (SessionHelper().empresa_logo != "" &&
        SessionHelper().empresa_logo != null) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(
                  "https://findooapp.com${SessionHelper().empresa_logo}"),
              fit: BoxFit.cover),
        ),
      );
    }
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: AssetImage("assets/images/splash_proveedor.png"),
            fit: BoxFit.fill),
      ),
    );
  }

  String ciudadName;
  Future getEmpresa() async {
    HttpHelper helper = HttpHelper();

    _empresa = await helper.obtenerEmpresa(SessionHelper().id.toString());

    setState(() {
      _empresa = _empresa;
    });
  }

  @override
  void initState() {
    cargarCiudades();
    getEmpresa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ciudadName == null) {
      ciudadName = "...";
    } else if (_empresa == null) {
      ciudadName = "...";
    } else
      ciudadName = ciudades != null &&
              ciudades
                      .where((element) => element.id == _empresa.ciudad)
                      .length >
                  0
          ? ciudades
              .where((element) => element.id == _empresa.ciudad)
              .first
              .nombre
          : "";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFoto(context),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              Provider.of<UserProvider>(context).first_name +
                                  " " +
                                  Provider.of<UserProvider>(context).last_name,
                              style: Theme.of(context).textTheme.headline6,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            Provider.of<UserProvider>(context).email,
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Image.asset(
                          "assets/images/isotipo.png",
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      Icon(
                        Icons.location_pin,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ciudadName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/encabezado_drawer.png"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            title: Text('Mi cuenta'),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilScreen(),
                  ));
              Scaffold.of(context).openEndDrawer();
            },
            leading: Icon(Icons.people_alt),
          ),
          SessionHelper().rol == "administrador"
              ? Container(
                  height: 0,
                )
              : ListTile(
                  title: Text('Notificaciones'),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificacionesRoute(),
                        ));
                    Scaffold.of(context).openEndDrawer();
                  },
                  leading: Icon(Icons.notifications),
                ),
          SessionHelper().rol == "administrador"
              ? Container(
                  height: 0,
                )
              : ListTile(
                  title: Text('Chat'),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaMensajesRoute(),
                        ));
                    Scaffold.of(context).openEndDrawer();
                  },
                  leading: Icon(Icons.chat),
                ),
          SessionHelper().rol == "administrador"
              ? Container(
                  height: 0,
                )
              : ListTile(
                  title: Text('Verificación de vales'),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificacionVales(),
                        ));
                    Scaffold.of(context).openEndDrawer();
                  },
                  leading: Icon(Icons.attach_money),
                ),
          ExpansionTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text("Más"),
            children: <Widget>[
              ListTile(
                leading: SizedBox(
                  width: 50,
                ),
                title: Text('Contáctanos'),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Contactanos(),
                      ));
                  Scaffold.of(context).openEndDrawer();
                },
              ),
              ListTile(
                leading: SizedBox(
                  width: 50,
                ),
                title: Text('Términos y condiciones'),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TerminosCondicionesRoute(),
                      ));
                  Scaffold.of(context).openEndDrawer();
                },
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Salir'),
            onTap: () {
              Provider.of<UserProvider>(context, listen: false).clearUserData();
              //SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}

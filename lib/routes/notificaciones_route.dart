import 'package:findooproveedor/models/notificacion.dart';
import 'package:findooproveedor/models/ultimo_mensaje.dart';
import 'package:findooproveedor/routes/chat_route.dart';
import 'package:findooproveedor/routes/solicitud_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:findooproveedor/widgets/widgets_pop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificacionesRoute extends StatefulWidget {
  @override
  _NotificacionesRouteState createState() => _NotificacionesRouteState();
}

class _NotificacionesRouteState extends State<NotificacionesRoute> {
  UltimoMensaje _ultimoMensaje = new UltimoMensaje();

  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FindooAppBar(
        disableNotificacionButton: true,
      ),
      body: FutureBuilder(
        future: HttpHelper().fetchNotificaciones(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Notificacion> not = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: not.length,
                  itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          if (SessionHelper().plancaducado == true) {
                            planCaducadoPop(context);
                          } else {
                            if (not[index].tipo == 3) {
                              HttpHelper()
                                  .obtenersolicitud(
                                      SessionHelper().id.toString(),
                                      not[index].codigo.toString())
                                  .then((solicitud) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SolicitudRoute(
                                        solicitud,
                                        createdFromMain: true,
                                      ),
                                    ));
                              });
                            } else {
                              HttpHelper()
                                  .getMensaje(not[index].codigo.toString())
                                  .then((value) {
                                _ultimoMensaje = value;

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatRoute(_ultimoMensaje),
                                    ));
                              });
                            }
                          }
                        },
                        leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.contain,
                              image: not[index].imagen == ""
                                  ? new AssetImage(
                                      "assets/images/usuarioSFoto.png")
                                  : new NetworkImage(
                                      "https://findooapp.com${not[index].imagen}"),
                            ),
                          ),
                        ),
                        title: Text(
                          not[index].texto,
                          style: TextStyle(
                              fontWeight: !not[index].leido
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                        subtitle: Text(
                          formatter.format(not[index].createdAt.toLocal()),
                        ),
                      )),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

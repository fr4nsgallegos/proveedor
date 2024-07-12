import 'package:findooproveedor/models/ultimo_mensaje.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:findooproveedor/widgets/widgets_pop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_route.dart';

class ListaMensajesRoute extends StatefulWidget {
  @override
  _ListaMensajesRouteState createState() => _ListaMensajesRouteState();
}

class _ListaMensajesRouteState extends State<ListaMensajesRoute> {
  final DateFormat hora = DateFormat('HH:mm');
  final DateFormat fecha = DateFormat('dd/MM/yy');

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d2.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FindooAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: HttpHelper().fetchUltimosMensajes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<UltimoMensaje> mensajes = snapshot.data;

              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: mensajes.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        image: mensajes[index].fotoCliente == ""
                            ? new AssetImage("assets/images/usuarioSFoto.png")
                            : new NetworkImage(mensajes[index].fotoCliente),
                      ),
                    ),
                  ),
                  title: (Text(mensajes[index].emisor != SessionHelper().id
                      ? mensajes[index].nombreEmisor
                      : mensajes[index].nombreReceptor,style: TextStyle(
                              fontWeight: !mensajes[index].leido
                                  ? FontWeight.bold
                                  : FontWeight.normal),)),
                  subtitle: (Text(mensajes[index].mensaje)),
                  trailing: isSameDate(
                          mensajes[index].createdAt.toLocal(), DateTime.now())
                      ? Text(hora.format(mensajes[index].createdAt.toLocal()))
                      : Text(fecha.format(mensajes[index].createdAt.toLocal())),
                  onTap: () {
                    if (SessionHelper().plancaducado == true) {
                      planCaducadoPop(context);
                    } else {
                      mensajes[index].leido=true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoute(mensajes[index]),
                          )).then((value) {
                            setState(() {
                              
                            });
                          });
                    }
                  },
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

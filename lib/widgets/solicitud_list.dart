import 'dart:ui';

import 'package:findooproveedor/models/solicitud.dart';
import 'package:findooproveedor/providers/solicitud_provider.dart';
import 'package:findooproveedor/routes/respuesta_solicitud_ver_route.dart';
import 'package:findooproveedor/routes/solicitud_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/widgets_pop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';

class SolicitudesList extends StatefulWidget {
  int estadoSolicitud;

  SolicitudesList(this.estadoSolicitud);
  @override
  _SolicitudesListState createState() => _SolicitudesListState(estadoSolicitud);
}

class _SolicitudesListState extends State<SolicitudesList>
    with AutomaticKeepAliveClientMixin {
  int estadoSolicitud;

  _SolicitudesListState(this.estadoSolicitud);

  @override
  Widget build(BuildContext context) {
    return _loadSolicitudes();
  }

  Widget _loadSolicitudes() {
    return SolicitudItemsList(estadoSolicitud);
  }

  @override
  bool get wantKeepAlive => true;
}

class SolicitudItemsList extends StatefulWidget {
  int estadoSolicitud;

  SolicitudItemsList(this.estadoSolicitud);
  @override
  _SolicitudItemsListState createState() =>
      _SolicitudItemsListState(estadoSolicitud);
}

class _SolicitudItemsListState extends State<SolicitudItemsList> {
  int estadoSolicitud;
  String filter = "";
  PopupMenu menuRecibidos;
  int solicitudSeleccionada;
  String planString;
  _SolicitudItemsListState(this.estadoSolicitud);
  List<Solicitud> _solicitudes = List<Solicitud>();
  List<Solicitud> _solicitudesDisplay = List<Solicitud>();
  String precioSiguientePlan;
  int rango; //controla el punto donde se divide la lista para acceder a las recibidas segun el tipo de plan

  void onClickRecibidosMenu(MenuItemProvider item) {
    HttpHelper helper = HttpHelper();
    if (widget.estadoSolicitud == 0) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Descartando solicitud")));
      helper.crearRespuestasolicitud(
        _solicitudesDisplay[solicitudSeleccionada].id.toString(),
        "Descartado",
        "0",
        "3",
        "0",
      );
    } else if (widget.estadoSolicitud == 1) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Registrando Venta")));
      helper.registrarVentaRespuestasolicitud(
          _solicitudesDisplay[solicitudSeleccionada]
              .estadoRespuesta
              .toString());
    } else if (widget.estadoSolicitud == 3) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Restaurando solicitud")));
      helper.eliminarRespuestasolicitud(
          _solicitudesDisplay[solicitudSeleccionada]
              .estadoRespuesta
              .toString());
    }
  }

  void filtradoPlanes() {
    if (SessionHelper().plan == 1) {
      rango = _solicitudes.length - 15;
      precioSiguientePlan = "150";
    } else if (SessionHelper().plan == 2) {
      rango = _solicitudes.length - 150;
      precioSiguientePlan = "250";
    } else if (SessionHelper().plan == 3) {
      rango = _solicitudes.length - 350;
      precioSiguientePlan = "350";
    } else if (SessionHelper().plan == 5) {
      rango = _solicitudes.length - 1000000;
    }
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    if (widget.estadoSolicitud == 0) {
      menuRecibidos = PopupMenu(
        items: [
          MenuItem(
              title: 'Descartar',
              image: Icon(
                Icons.delete,
                color: Colors.white,
              )),
        ],
        onClickMenu: onClickRecibidosMenu,
      );
    } else if (widget.estadoSolicitud == 1) {
      menuRecibidos = PopupMenu(
        items: [
          MenuItem(
              title: 'Vendido',
              image: Icon(
                Icons.monetization_on,
                color: Colors.white,
              )),
        ],
        onClickMenu: onClickRecibidosMenu,
      );
    } else {
      menuRecibidos = PopupMenu(
        items: [
          MenuItem(
              title: 'Restaurar',
              image: Icon(
                Icons.undo,
                color: Colors.white,
              )),
        ],
        onClickMenu: onClickRecibidosMenu,
      );
    }

    if (estadoSolicitud == 0) {
      _solicitudes =
          Provider.of<SolicitudProvider>(context).solicitudesRecibidas;
    }
    if (estadoSolicitud == 1) {
      _solicitudes =
          Provider.of<SolicitudProvider>(context).solicitudesEnviadas;
    }
    if (estadoSolicitud == 3) {
      _solicitudes =
          Provider.of<SolicitudProvider>(context).solicitudesPapelera;
    }

    if (_solicitudes == null || _solicitudesDisplay == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    filtradoPlanes();

    if (_solicitudes != null) {
      _solicitudesDisplay = _solicitudes.where((Solicitud) {
        var palabra = Solicitud.compradorNombre.toLowerCase();
        var productoNombre = Solicitud.nombreProducto.toLowerCase();
        return palabra.contains(filter) || productoNombre.contains(filter);
      }).toList();
    }

    return Container(
      child: Column(
        children: [
          _searchbar(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _listItem(index);
              },
              itemCount: _solicitudesDisplay.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _listItem(index) {
    final DateFormat formatter = DateFormat('HH:mm \n yyyy-MM-dd');
    GlobalKey btnKey = GlobalKey();
    FontWeight weight = FontWeight.normal;
    if (_solicitudesDisplay[index].estadoRespuesta == 0) {
      weight = FontWeight.bold;
    }
    return ListTile(
      onTap: () async {
        if (SessionHelper().plancaducado == true) {
          planCaducadoPop(context);
        } else {
          if (index >= rango) {
            dynamic res;
            if (widget.estadoSolicitud == 1) {
              res = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return RespuestaVerRoute(
                  _solicitudesDisplay[index],
                  createdFromMain: true,
                );
              }));
            } else {
              res = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return SolicitudRoute(
                  _solicitudesDisplay[index],
                  createdFromMain: true,
                );
              }));
            }

            if (res != null)
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("$res")));
            Provider.of<SolicitudProvider>(context, listen: false)
                .fetchSolicitudesEnviadas();
            Provider.of<SolicitudProvider>(context, listen: false)
                .fetchSolicitudesRecibidas();
            Provider.of<SolicitudProvider>(context, listen: false)
                .fetchSolicitudesPapelera();
          } else {
            if (_solicitudesDisplay[index].estadoRespuesta > 0) {
              dynamic res;

              res = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return RespuestaVerRoute(
                  _solicitudesDisplay[index],
                  createdFromMain: true,
                );
              }));
            } else
              limiteSolicitudesPop(context, precioSiguientePlan);
          }
        }
      },
      title: Text(
        _solicitudesDisplay[index].nombreProducto != 'Otros'
            ? _solicitudesDisplay[index].nombreProducto
            : _solicitudesDisplay[index].productoPadres + "- Otros",
        style: TextStyle(fontWeight: weight),
      ),
      subtitle: Text(
        _solicitudesDisplay[index].compradorNombre,
        style: TextStyle(fontWeight: weight),
      ),
      leading: Image.network(
        "https://findooapp.com${_solicitudesDisplay[index].productoImagen}",
        width: 30,
        height: 30,
      ),
      trailing: Wrap(
        children: [
          Text(
            formatter.format(
                DateTime.parse(_solicitudesDisplay[index].createdAt).toLocal()),
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 12, color: Colors.grey, fontWeight: weight),
          ),
          widget.estadoSolicitud != 0 ||
                  _solicitudesDisplay[index].estadoRespuesta == 0
              ? GestureDetector(
                  key: btnKey,
                  onTapUp: (TapUpDetails details) {
                    solicitudSeleccionada = index;
                    menuRecibidos.show(widgetKey: btnKey);
                  },
                  child: SessionHelper().rol == "administrador"
                      ? Container(
                          width: 0,
                        )
                      : Icon(Icons.more_vert))
              : Container(
                  width: 5,
                )
        ],
      ),
    );
  }

  TextEditingController palabraController;
  bool _enabled = false;
  _searchbar() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: _enabled
            ? new TextFormField(
                enableInteractiveSelection: false,
                autofocus: false,
                style: TextStyle(
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.clear),
                    onTap: () {
                      setState(() {
                        _enabled = !_enabled;
                        filter = "";
                      });
                    },
                  ),
                  hintText: "Buscar",
                  hintStyle: TextStyle(color: Colors.black),
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFF7ED956),
                    size: 28,
                  ),
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(
                    () {
                      if (text.length > 1) {
                        filter = text;
                      } else {
                        filter = "";
                      }
                    },
                  );
                },
              )
            : new FocusScope(
                child: new TextFormField(
                  enableInteractiveSelection: false,
                  autofocus: false,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.clear),
                      onTap: () {
                        setState(() {
                          _enabled = !_enabled;
                          filter = "";
                        });
                      },
                    ),
                    hintText: "Buscar",
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFF7ED956),
                      size: 28,
                    ),
                  ),
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(
                      () {
                        if (text.length > 1) {
                          filter = text;
                        } else {
                          filter = "";
                        }
                      },
                    );
                  },
                ),
              ));
  }
}

import 'package:another_flushbar/flushbar.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

Widget _buildFoto(BuildContext context) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage(
            "assets/images/isotipo_verde.png",
          ),
          fit: BoxFit.contain),
    ),
  );
}

Future<void> abrirEnlace(String url) async {
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

void limiteSolicitudesPop(BuildContext context, String precioSiguienteplan) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      elevation: 24,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildFoto(context),
            SizedBox(
              height: 30,
            ),
            Text(
              "Lo sentimos :(",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Has excedido el límite de solicitudes permitidas según tu plan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // FlatButton(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: [
            //         Text(
            //           "Mejora tu plan",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20,
            //           ),
            //         ),
            //         Text(
            //           "desde S/ $precioSiguienteplan.00 al mes",
            //           style: TextStyle(fontSize: 12),
            //         )
            //       ],
            //     ),
            //   ),
            //   color: Colors.red,
            //   textColor: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   onPressed: () {
            //     abrirEnlace("https://findooapp.com/planes/#planes");
            //   },
            // ),
          ],
        ),
      ),
    ),
  );
}

void planCaducadoPop(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      elevation: 24,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildFoto(context),
            SizedBox(
              height: 30,
            ),
            Text(
              "Lo sentimos :(",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Tu plan ha caducado",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // FlatButton(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: [
            //         Text(
            //           "Renueva tu plan",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   color: Colors.red,
            //   textColor: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   onPressed: () {
            //     abrirEnlace(
            //         " https://findooapp.com/proveedor/#opciones-afiliacion");
            //   },
            // ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.lightGreen,
                size: 45,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRow(Icon icono, String titulo, String subtitulo) {
  return Container(
    width: 1000,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 10,
          height: 35,
        ),
        icono,
        SizedBox(
          width: 12,
          height: 35,
        ),
        Text(
          titulo,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        subtitulo == null ? Text("-") : Flexible(child: Text(subtitulo)),
      ],
    ),
  );
}

void canjearValeAccion(String idcupon, BuildContext context) async {
  bool cupon = await HttpHelper().canjearCupon(idcupon);

  if (cupon) {
    Navigator.pop(context);
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      message: "Vale canjeado",
      duration: Duration(seconds: 1),
    )..show(context);
  } else {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      message: "El vale no se puede canjear",
      duration: Duration(seconds: 1),
    )..show(context);
  }
}

void canjearValePop(
  BuildContext context,
  String cliente,
  String usado,
  String empresa,
  String valor,
  String idcupon,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      elevation: 24,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildFoto(context),
            SizedBox(
              height: 30,
            ),
            Text(
              "Vale correcto",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildRow(Icon(Icons.people), "Cliente:", cliente),
            _buildRow(Icon(Icons.check), "Uso:", usado),
            _buildRow(Icon(Icons.business), "Empresa:", empresa),
            _buildRow(Icon(Icons.attach_money), "Valor:", "S/ $valor"),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Canjear vale",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.lightGreen,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: () async {
                canjearValeAccion(idcupon, context);
              },
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.lightGreen,
                size: 45,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.lightGreen,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Widget _buildBoxContrasena(
    String nombre, var dato, Icon icono, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        nombre,
        style: TextStyle(
          color: Color(0xFF537445),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 60,
        child: TextField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: icono,
              hintText: dato,
              hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
      SizedBox(
        height: 15,
      )
    ],
  );
}

void cambiarContrasenaPop(
  BuildContext context,
) {
  TextEditingController contrasena1 = TextEditingController();
  TextEditingController contrasena2 = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      elevation: 24,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildFoto(context),
            SizedBox(
              height: 30,
            ),
            Text(
              "Actualizar contraseña",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildBoxContrasena("Contraseña", "Ingrese la nueva contraseña",
                Icon(Icons.lock), contrasena1),
            _buildBoxContrasena(
                "Confirmar contraseña",
                "Vuelva a ingresar la contraseña",
                Icon(Icons.lock_outline_rounded),
                contrasena2),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Actualizar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.lightGreen,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: () async {
                if (contrasena1.text == contrasena2.text) {
                  if (contrasena1.text == "" || contrasena2.text == "") {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.BOTTOM,
                      message: "Ingrese una constraseña válida",
                      duration: Duration(seconds: 5),
                    )..show(context);
                  } else
                    HttpHelper()
                        .postCambiarContrasena(
                            SessionHelper().id, contrasena1.text)
                        .then((value) {
                      Navigator.pop(context);
                      Flushbar(
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        message:
                            "Su contraseña se ha actualizado correctamente",
                        duration: Duration(seconds: 5),
                      )..show(context);
                    });
                } else {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    message: "Las contraseñas no coinciden",
                    duration: Duration(seconds: 5),
                  )..show(context);
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            FlatButton(
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.lightGreen,
                size: 45,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

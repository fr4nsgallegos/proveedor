import 'package:findooproveedor/models/cupon.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:findooproveedor/widgets/widgets_pop.dart';
import 'package:flutter/material.dart';

class VerificacionVales extends StatefulWidget {
  @override
  _VerificacionValesState createState() => _VerificacionValesState();
}

class _VerificacionValesState extends State<VerificacionVales> {
  GlobalKey<ScaffoldState> scafoldkey = GlobalKey();
  bool isAsyncCall = false;
  TextEditingController mensajeController = TextEditingController();
  Cupon _cupon;
  String idCupon;
  String mensajeUsado;
  HttpHelper helper = HttpHelper();

  Future getCupon(String id) async {
    _cupon = await helper.getCupon(id);
    setState(() {
      _cupon = _cupon;
      if (_cupon.usado == false) {
        mensajeUsado = "Cupón no usado";
      } else {
        mensajeUsado = "Cupón usado";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      appBar: FindooAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35, bottom: 25),
            child: Text(
              "Verificación de vales",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Center(
            child: Container(
              width: 350,
              child: TextField(
                cursorColor: Color(0x537445),
                controller: mensajeController,
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Ingrese el código de vale",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 25, horizontal: 87),
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () async {
                  idCupon =
                      (int.parse(mensajeController.text) - 100).toString();
                  dynamic cupon = await HttpHelper().verificarCupon((idCupon));

                  if (cupon is String) {
                    scafoldkey.currentState.showSnackBar(
                        SnackBar(content: Text("Vale para $cupon")));
                  } else if (cupon == true) {
                    await getCupon(idCupon);

                    canjearValePop(
                      context,
                      _cupon.clienteNombre,
                      mensajeUsado,
                      _cupon.empresaNombre,
                      _cupon.valor.toString(),
                      idCupon,
                    );
                  } else {
                    scafoldkey.currentState.showSnackBar(
                        SnackBar(content: Text("Vale incorrecto")));
                  }
                },
                textColor: Colors.white,
                child: Text("Verificar vale"),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

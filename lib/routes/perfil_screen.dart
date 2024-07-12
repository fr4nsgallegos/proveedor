import 'package:findooproveedor/models/empresa.dart';
import 'package:findooproveedor/models/usuario.dart';
import 'package:findooproveedor/providers/user_provider.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:findooproveedor/widgets/widgets_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool editPwd = false;
  TextEditingController txtPassword = TextEditingController();
  Map<int, String> planes = {
    1: "PLAN FREE",
    2: "PLAN BÁSICO",
    3: "PLAN ESTANDAR",
    5: "PLAN PREMIUM"
  };
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

  Widget _buildFoto() {
    if (SessionHelper().empresa_logo != "" &&
        SessionHelper().empresa_logo != null) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
                "https://findooapp.com${SessionHelper().empresa_logo}"),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage("assets/images/splash_proveedor.png"),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Widget _buildBox(String nombre, var dato, Icon icono) {
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
            readOnly: true,
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

  @override
  Widget build(BuildContext context) {
    Future<Empresa> empresa;
    empresa = HttpHelper()
        .obtenerEmpresa(Provider.of<UserProvider>(context).id.toString());

    return Scaffold(
      appBar: FindooAppBar(),
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: FutureBuilder<Empresa>(
              future: empresa,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.white38,
                              ]),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 40.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildFoto(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Mis Datos',
                                style: TextStyle(
                                  color: Color(0xFF537445),
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              _buildBox(
                                  "Razón Social",
                                  snapshot.data.razonSocial,
                                  Icon(
                                    Icons.perm_identity,
                                    color: Colors.white,
                                  )),
                              _buildBox(
                                "Nombres:",
                                Provider.of<UserProvider>(context).first_name,
                                Icon(
                                  Icons.people,
                                  color: Colors.white,
                                ),
                              ),
                              _buildBox(
                                "Apellidos:",
                                Provider.of<UserProvider>(context).last_name,
                                Icon(
                                  Icons.people,
                                  color: Colors.white,
                                ),
                              ),
                              _buildBox(
                                "Correo electrónico:",
                                Provider.of<UserProvider>(context).email,
                                Icon(
                                  Icons.alternate_email,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _buildBox(
                                "Plan contratado",
                                planes[snapshot.data.plan],
                                Icon(
                                  Icons.fact_check,
                                  color: Colors.white,
                                ),
                              ),
                              _buildBox(
                                "Fecha de vencimiento:",
                                snapshot.data.fechaVencimiento,
                                Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                onPressed: () async {
                                  print(Provider.of<UserProvider>(context,
                                          listen: false)
                                      .categorias);
                                  cambiarContrasenaPop(context);
                                },
                                child: Text(
                                  "Actualizar contraseña",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    width: 0,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

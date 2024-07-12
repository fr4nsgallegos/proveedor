import 'package:another_flushbar/flushbar.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormularioScreen extends StatefulWidget {
  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  TextEditingController txtRazonSocial = TextEditingController();
  TextEditingController txtRuc = TextEditingController();
  TextEditingController txtRazonComercial = TextEditingController();
  TextEditingController txtCodDescarga = TextEditingController();
  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtDNI = TextEditingController();
  TextEditingController txtTelefono = TextEditingController();
  TextEditingController txtCorreo = TextEditingController();
  bool flag = false;
  final kBoxDecorationField = BoxDecoration(
    color: Color(0xFFD9D9D9),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _buildBox(String nombre, String dato, Icon icono,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nombre,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationField,
          height: 60,
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.black54),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: icono,
                hintText: dato,
                hintStyle: TextStyle(color: Colors.black54)),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget _buildTituloField(String text1, String text2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text2,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget formulario1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Text(
              '¡estás a un click de cambiar tu negocio...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'para siempre!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightGreen,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        _buildTituloField("FORMULARIO DE AFILIACIÓN",
            "Envíanos tus datos y evaluaremos tu solicitud de afiliación"),
        _buildBox(
            "RAZÓN SOCIAL",
            "Indícanos tu razón social",
            Icon(
              Icons.perm_identity,
            ),
            txtRazonSocial),
        _buildBox(
          "RUC (OPCIONAL)",
          "Indícanos tu RUC",
          Icon(
            Icons.format_indent_decrease,
          ),
          txtRuc,
        ),
        _buildBox(
          "RAZÓN COMERCIAL",
          "Indícanos tu razón comercial",
          Icon(
            Icons.people,
          ),
          txtRazonComercial,
        ),
        _buildBox(
          "CÓDIGO DE DESCARGA (OPCIONAL)",
          "Código de quien te recomendó ser proveedor",
          Icon(
            Icons.code,
          ),
          txtCodDescarga,
        ),
        SizedBox(
          height: 20,
        ),
        _buildTituloField("INFORMACIÓN DE CONTACTO",
            "Déjanos los datos del representante y/o persona de contacto"),
        _buildBox("NOMBRE COMPLETO", "Nombre de la persona de contacto",
            Icon(Icons.contact_page), txtNombre),
        _buildBox("DOCUMENTO DE IDENTIDAD", "Número de DNI",
            Icon(Icons.perm_identity_rounded), txtDNI),
        _buildBox("TELÉFONO", "Telefono de la persona de contacto",
            Icon(Icons.phone), txtTelefono),
        _buildBox("CORREO ELECTRÓNICO", "Correo de la persona de contacto",
            Icon(Icons.email), txtCorreo),
        SizedBox(
          height: 25,
        ),
        Center(
          child: FlatButton(
            onPressed: () {
              if (txtRazonSocial.text.isEmpty ||
                  txtRazonComercial.text.isEmpty ||
                  txtNombre.text.isEmpty ||
                  txtDNI.text.isEmpty ||
                  txtTelefono.text.isEmpty ||
                  txtCorreo.text.isEmpty) {
                Flushbar(
                  flushbarPosition: FlushbarPosition.BOTTOM,
                  message: "Faltan datos por llenar",
                  duration: Duration(seconds: 5),
                )..show(context);
              } else {
                setState(() {
                  flag = true;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                "SIGUIENTE",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen),
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ],
    );
  }

  Map<int, bool> catId = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    10: false,
    11: false,
    12: false,
    13: false,
    14: false,
    15: false,
    16: false,
    17: false,
    18: false,
    19: false,
  };

  List<int> categorias = [];
  Widget _buildCheckBox(String nombre, int id) {
    return Container(
      height: 35,
      child: CheckboxListTile(
          title: Text(nombre),
          value: catId[id],
          contentPadding:
              EdgeInsets.only(top: 0, bottom: 0, left: 45, right: 45),
          activeColor: Colors.lightGreen,
          checkColor: Colors.black,
          selected: catId[id],
          onChanged: (bool value) {
            setState(() {
              catId[id] = value;
            });
            print(catId[id]);
            if (catId[id] == true) {
              categorias.add(id);
            } else {
              categorias.remove(id);
            }
          }),
    );
  }

  Widget formulario2() {
    return Column(
      children: [
        _buildTituloField("SELECCIÓN DE CATEGORÍAS",
            "¡Esta sección es muy importante! Aquí podrás seleccionar todas las categorías de productos que tienes en stock... elige sabiamente..."),
        SizedBox(
          height: 20,
        ),
        _buildCheckBox("Electrohogar", 1),
        _buildCheckBox("Tecnología", 2),
        _buildCheckBox("Hogar", 3),
        _buildCheckBox("Deportes", 4),
        _buildCheckBox("Moda y Accesorios", 5),
        _buildCheckBox("Calzado", 6),
        _buildCheckBox("Infantil", 7),
        _buildCheckBox("Salud y Belleza", 8),
        _buildCheckBox("Maletería", 9),
        _buildCheckBox("Libros", 10),
        _buildCheckBox("Escolar", 11),
        _buildCheckBox("Música y Arte", 12),
        _buildCheckBox("Automóviles y Motocicletas", 13),
        _buildCheckBox("Mascotas", 14),
        _buildCheckBox("Bodas", 15),
        _buildCheckBox("Herramientas y Ferretería", 16),
        _buildCheckBox("Florerías y Detalles", 17),
        _buildCheckBox("Pastelería", 18),
        _buildCheckBox("Otros", 19),
        SizedBox(
          height: 30,
        ),
        Center(
          child: FlatButton(
            onPressed: () {
              HttpHelper()
                  .postRegitroForm(
                txtRazonSocial.text,
                txtRuc.text,
                txtCodDescarga.text,
                txtRazonComercial.text,
                txtDNI.text,
                txtTelefono.text,
                txtCorreo.text,
                txtNombre.text,
                categorias,
              )
                  .then((value) {
                Navigator.pop(context);
                Flushbar(
                  flushbarPosition: FlushbarPosition.BOTTOM,
                  message:
                      "Gracias, validaremos la veracidad de tu negocio y te enviaremos las credenciales de acceso",
                  duration: Duration(seconds: 5),
                )..show(context);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                "REGISTRAR",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen),
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FindooAppBar(),
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
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
                          children: [
                            flag == false ? formulario1() : formulario2()
                          ],
                        )),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

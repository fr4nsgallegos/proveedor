import 'package:another_flushbar/flushbar.dart';
import 'package:findooproveedor/models/categoria.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class formularioAfiliacion extends StatefulWidget {
  formularioAfiliacion({Key key}) : super(key: key);

  @override
  _formularioAfiliacionState createState() => _formularioAfiliacionState();
}

class _formularioAfiliacionState extends State<formularioAfiliacion> {
  TextEditingController txtRazonSocial = TextEditingController();
  TextEditingController txtRazonComercial = TextEditingController();
  TextEditingController txtRuc = TextEditingController();
  TextEditingController txtCodDescarga = TextEditingController();
  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtDNI = TextEditingController();
  TextEditingController txtTelefono = TextEditingController();
  TextEditingController txtCorreo = TextEditingController();
  TextEditingController txtDireccion = TextEditingController();
  TextEditingController txtDireccionMaps = TextEditingController();
  TextEditingController txtHorarioAtencion = TextEditingController();
  TextEditingController txtMedioPago = TextEditingController();
  TextEditingController txtVendedor1 = TextEditingController();
  TextEditingController txtVendedor2 = TextEditingController();
  TextEditingController txtVendedor3 = TextEditingController();
  TextEditingController txtAdministrador = TextEditingController();
  List<Categoria> _categoriasAll = [];
  List<Categoria> _categorias1 = [];
  List<Categoria> _categorias2 = [];
  List<Categoria> _categorias3 = [];

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

  Future cargarCategorias() async {
    _categoriasAll = await HttpHelper().getCategorias();
    setState(() {
      _categoriasAll = _categoriasAll;
      _categorias1 =
          _categoriasAll.where((element) => element.nivel == 1).toList();
      _categorias2 =
          _categoriasAll.where((element) => element.nivel == 2).toList();
      _categorias3 =
          _categoriasAll.where((element) => element.nivel == 3).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      cargarCategorias();
    });
  }

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
          "RAZÓN COMERCIAL",
          "Indícanos tu razón comercial",
          Icon(
            Icons.people,
          ),
          txtRazonComercial,
        ),
        _buildBox(
          "RUC (OPCIONAL)",
          "Indícanos tu RUC",
          Icon(
            Icons.format_indent_decrease,
          ),
          txtRuc,
        ),
        _buildBox("TELÉFONO", "Telefono de la persona de contacto",
            Icon(Icons.phone), txtTelefono),
        _buildBox("CORREO ELECTRÓNICO", "Correo de la persona de contacto",
            Icon(Icons.email), txtCorreo),
        _buildBox("DIRECCIÓN", "Indícanos tu dirección", Icon(Icons.directions),
            txtDireccion),
        _buildBox(
            "UBICACIÓN EN GOOLE MAPS",
            "Busca tu negocio en google maps y copia el enlace",
            Icon(Icons.location_on),
            txtDireccionMaps),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: GestureDetector(
              child: Hero(
                tag: 'instructivoMap',
                child: Text(
                  "Ver imagen",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return imageScreen();
                    },
                  ),
                );
              },
            ),
          ),
        ),
        _buildBox("HORARIO DE ATENCIÓN", "Indícanos tu horario de atención",
            Icon(Icons.access_time), txtHorarioAtencion),
        _buildBox("MEDIO DE PAGO", "Yape, plin, efectivo, etc",
            Icon(Icons.attach_money_outlined), txtMedioPago),
        SizedBox(
          height: 20,
        ),
        _buildTituloField("CREDENCIALES DE ACCESO", ""),
        _buildBox(
            "Vendedor #1",
            "Las credenciales de acceso pertenecen a la sesión actual",
            Icon(Icons.perm_identity_rounded),
            txtVendedor1),
        _buildBox("Vendedor #2", "Nombre y apellido",
            Icon(Icons.perm_identity_rounded), txtVendedor2),
        _buildBox("Vendedor #3", "Nombre y apellido",
            Icon(Icons.perm_identity_rounded), txtVendedor3),
        _buildBox("Administrador", "Nombre y apellido",
            Icon(Icons.perm_identity_rounded), txtAdministrador),
        SizedBox(
          height: 25,
        ),
        Center(
          child: FlatButton(
            onPressed: () {
              print(_categorias2.length);
              setState(() {
                flag = true;
              });
              // if (txtRazonSocial.text.isEmpty ||
              //     txtRazonComercial.text.isEmpty ||
              //     txtTelefono.text.isEmpty ||
              //     txtDireccion.text.isEmpty ||
              //     txtDireccionMaps.text.isEmpty ||
              //     txtHorarioAtencion.text.isEmpty ||
              //     txtMedioPago.text.isEmpty ||
              //     txtVendedor1.text.isEmpty) {
              //   Flushbar(
              //     flushbarPosition: FlushbarPosition.BOTTOM,
              //     message: "Faltan datos por llenar",
              //     duration: Duration(seconds: 5),
              //   )..show(context);
              // } else {
              //   bool emailValid = RegExp(
              //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              //       .hasMatch(txtCorreo.text);
              //   if (emailValid == true) {
              //     setState(() {
              //       flag = true;
              //     });
              //   } else {
              //     Flushbar(
              //       flushbarPosition: FlushbarPosition.BOTTOM,
              //       message: "Correo electrónico inválido",
              //       duration: Duration(seconds: 5),
              //     )..show(context);
              //   }
              // }
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

  List<int> categorias = [];
  Widget _buildCheckBox(Categoria subcate) {
    print(subcate.value);
    return Container(
      height: 35,
      child: CheckboxListTile(
          title: Text(
            subcate.descripcion,
            overflow: TextOverflow.ellipsis,
          ),
          value: subcate.value,
          contentPadding:
              EdgeInsets.only(top: 0, bottom: 0, left: 45, right: 45),
          activeColor: Colors.lightGreen,
          checkColor: Colors.black,
          selected: subcate.value,
          onChanged: (bool value) {
            setState(() {
              subcate.value = value;
            });

            if (subcate.value == true) {
              categorias.add(subcate.id);
            } else {
              categorias.remove(subcate.id);
            }
          }),
    );
  }

  List<Widget> _buildExpansion(List<Categoria> catList) {
    List<Widget> aux = [];
    List<Widget> aux1;
    catList.forEach(
      (element) {
        aux1 = _subcategorias(element.id);
        print("asdasdasdasd ${element.id}");
        setState(
          () {
            aux.add(
              ExpansionTile(
                childrenPadding: EdgeInsets.only(bottom: 20),
                title: Text(element.descripcion),
                tilePadding: EdgeInsets.all(2),
                expandedAlignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: aux1,
                  )
                ],
              ),
            );
          },
        );
      },
    );

    return aux;
  }

  List<Widget> _subcategorias(int padre) {
    List<Categoria> aux = [];
    List<Widget> aux1 = [];
    setState(() {
      aux = _categoriasAll.where((element) => element.padre == padre).toList();
      aux.forEach((element) {
        aux1.add(_buildCheckBox(element));
      });
    });

    return aux1;
  }

  Widget formulario2() {
    return Column(
      children: [
        _buildTituloField("SELECCIÓN DE CATEGORÍAS",
            "¡Esta sección es muy importante! Aquí podrás seleccionar todas las categorías de productos que tienes en stock... elige sabiamente..."),
        SizedBox(
          height: 20,
        ),
        Column(
          children: _buildExpansion(_categorias1),
        ),
        SizedBox(
          height: 30,
        ),
        Center(
          child: FlatButton(
            onPressed: () {
              HttpHelper()
                  .postRegitroForm2(
                      txtRazonSocial.text,
                      txtRazonComercial.text,
                      txtRuc.text,
                      txtTelefono.text,
                      txtCorreo.text,
                      txtDireccion.text,
                      txtDireccionMaps.text,
                      txtHorarioAtencion.text,
                      txtMedioPago.text,
                      txtVendedor1.text,
                      txtVendedor2.text,
                      txtVendedor3.text,
                      txtVendedor3.text,
                      categorias)
                  .then((value) {
                Navigator.pop(context);
                Flushbar(
                  flushbarPosition: FlushbarPosition.BOTTOM,
                  message:
                      "Gracias, validaremos la categoria de tu negocio para que continues usando la aplicación",
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

class imageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'instructivoMap',
            child: Image.asset(
              "assets/images/instructivo_google_maps.png",
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

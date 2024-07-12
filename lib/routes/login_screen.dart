import 'dart:convert';
import 'dart:math';

import 'package:findooproveedor/providers/user_provider.dart';
import 'package:findooproveedor/routes/registro_screen.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:findooproveedor/commons/consts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool inAsyncCall = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TextEditingController usr = TextEditingController();

  TextEditingController pwd = TextEditingController();

  // void _login(BuildContext context) async {
  //   var response = await http.post(Constantes.url + "api-token-auth/",
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: json.encode({"username": usr.text, "password": pwd.text}));

  //   if (response.statusCode == 200) {
  //     var r = jsonDecode(response.body);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString("token", r["token"]);
  //     await _getUserData(r["token"], context);
  //     _firebaseMessaging.getToken().then((String token) {
  //       assert(token != null);
  //       print(token);
  //       HttpHelper().actualizarToken(token);
  //     });
  //   } else {
  //     print(response.body);
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           "Usuario o contraseña inválido",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         duration: Duration(seconds: 4),
  //       ),
  //     );
  //   }
  //   setState(() {
  //     inAsyncCall = false;
  //   });
  // }

  // Future _getUserData(String token, BuildContext context) async {
  //   var response = await http.post(
  //     Constantes.url + "usuario/",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'JWT ' + token
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     var r = jsonDecode(response.body);
  //     print(response.body);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setInt("id", r["id"]);
  //     prefs.setString("email", r["email"]);
  //     prefs.setString("first_name", r["first_name"]);
  //     prefs.setString("last_name", r["last_name"]);
  //     prefs.setString("imagen", r["imagen"]);
  //     prefs.setString("codigo_promocion", r["codigo_promocion"]);
  //     prefs.setString("rol", r["rol"]);
  //     prefs.setInt("categorias", r["categorias"]);
  //     Provider.of<UserProvider>(context, listen: false).fetchUserData();
  //   } else if (Provider.of<UserProvider>(context).rol == "comprador") {
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           "Usuario o contraseña inválido",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         duration: Duration(seconds: 4),
  //       ),
  //     );
  //   } else {
  //     print(response.body);
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(
  //         //backgroundColor: Colors.lightGreen,
  //         content: Text(
  //           "Usuario o contraseña inválido",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         duration: Duration(seconds: 4),
  //       ),
  //     );
  //   }
  // }
  void _login(BuildContext context) async {
    setState(() {
      inAsyncCall = true;
    });

    var response = await http.post(Constantes.url + "api-token-auth/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({"username": usr.text, "password": pwd.text}));

    if (response.statusCode == 200) {
      var r = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", r["token"]);
      await _getUserData(r["token"], context);
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print(token);
        HttpHelper().actualizarToken(token);
      });
    } else {
      print(response.body);
      if (mounted) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Usuario o contraseña inválido",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        inAsyncCall = false;
      });
    }
  }

  Future _getUserData(String token, BuildContext context) async {
    var response = await http.post(
      Constantes.url + "usuario/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + token
      },
    );

    if (response.statusCode == 200) {
      var r = jsonDecode(response.body);
      print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("id", r["id"]);
      prefs.setString("email", r["email"]);
      prefs.setString("first_name", r["first_name"]);
      prefs.setString("last_name", r["last_name"]);
      prefs.setString("imagen", r["imagen"]);
      prefs.setString("codigo_promocion", r["codigo_promocion"]);
      prefs.setString("rol", r["rol"]);
      prefs.setInt("categorias", r["categorias"]);
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).fetchUserData();
      }
    } else {
      if (mounted) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Usuario o contraseña inválido",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        inAsyncCall: inAsyncCall,
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFF7ED956),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 200,
                      child: Center(
                        child: Image.asset(
                          "assets/images/nombre_transparencia.png",
                          height: 80,
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: CurvedTopClipper(),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height - 220,
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "INICIAR SESIÓN",
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Icon(
                                              Icons.account_circle,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25)),
                                              ),
                                              child: TextField(
                                                controller: usr,
                                                cursorColor: Colors.grey,
                                                decoration: new InputDecoration(
                                                  hintText: "USUARIO",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Icon(
                                              Icons.lock,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25)),
                                              ),
                                              child: TextField(
                                                controller: pwd,
                                                obscureText: true,
                                                cursorColor: Colors.grey,
                                                decoration: new InputDecoration(
                                                  hintText: "******",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _login(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Text(
                                        "INGRESAR",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                    color: Colors.lightGreen,
                                    shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.lightGreen),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 26,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegistroScreen(),
                                          ));
                                      // Scaffold.of(context).openEndDrawer();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("No tienes una cuenta? "),
                                        Text(
                                          "Regístrate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade800),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // I've taken approximate height of curved part of view
    // Change it if you have exact spec for it
    final roundingHeight = size.height * 3 / 50;

    // this is top part of path, rectangle without any rounding
    final filledRectangle = Rect.fromLTRB(
        0, roundingHeight, size.width, size.height - roundingHeight);

    // this is rectangle that will be used to draw arc
    // arc is drawn from center of this rectangle, so it's height has to be twice roundingHeight
    // also I made it to go 5 units out of screen on left and right, so curve will have some incline there
    final roundingRectangle =
        Rect.fromLTRB(-5, 0, size.width + 5, roundingHeight * 2);

    final path = Path();
    path.addRect(filledRectangle);

    // so as I wrote before: arc is drawn from center of roundingRectangle
    // 2nd and 3rd arguments are angles from center to arc start and end points
    // 4th argument is set to true to move path to rectangle center, so we don't have to move it manually
    path.arcTo(roundingRectangle, -pi, pi, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

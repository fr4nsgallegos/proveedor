import 'dart:async';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:findooproveedor/eliminar.dart';
import 'package:findooproveedor/models/empresa.dart';
import 'package:findooproveedor/providers/notifications_provider.dart';
import 'package:findooproveedor/providers/user_provider.dart';
import 'package:findooproveedor/routes/formulario_afiliacion_screen.dart';
import 'package:findooproveedor/routes/lista_mensajes_route.dart';
import 'package:findooproveedor/routes/login_screen.dart';
import 'package:findooproveedor/routes/notificaciones_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/findoo_navdrawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'providers/solicitud_provider.dart';
import 'widgets/solicitud_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Findoo Proveedor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyWidget(),

        //  SplashScreen(
        //   seconds: 2,
        //   loaderColor: Colors.white,
        //   imageBackground: AssetImage("assets/images/splash_proveedor.png"),
        //   navigateAfterSeconds: MultiProvider(
        //     providers: [
        //       ChangeNotifierProvider(create: (context) => SolicitudProvider()),
        //     ],
        //     child: MyHomePage(title: 'Flutter Demo Home Page'),
        //   ),
        // ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showInstructions = false;
  Empresa empresa;
  bool _loggedIn = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isAdministrador = false;
  bool planCaducado = false;

  Timer t;
  SharedPreferences prefs;

  consultarSolicitudes(BuildContext context) {
    if (t != null) t.cancel();
    t = Timer.periodic(Duration(seconds: 5), (timer) {
      Provider.of<SolicitudProvider>(context, listen: false)
          .fetchSolicitudesEnviadas();
      Provider.of<SolicitudProvider>(context, listen: false)
          .fetchSolicitudesPapelera();
      Provider.of<SolicitudProvider>(context, listen: false)
          .fetchSolicitudesRecibidas();
      Provider.of<NotificationsProvider>(context, listen: false)
          .fetchNotificaciones();
    });
  }

  Future fetchTipoPlan() async {
    HttpHelper helper = HttpHelper();
    print("USER ID:   ${SessionHelper().id.toString()}");

    empresa = await helper.obtenerEmpresa(SessionHelper().id.toString());
    SessionHelper().plan = empresa.plan;
    SessionHelper().fecha_vencimiento = empresa.fechaVencimiento;
    SessionHelper().empresa_logo = empresa.imagen;

    if (DateTime.parse(SessionHelper().fecha_vencimiento)
        .isBefore(DateTime.now())) {
      planCaducado = true;
      SessionHelper().plancaducado = true;
    } else {
      SessionHelper().plancaducado = false;
    }
  }

  Future checkFirstSeen() async {
    prefs = await SharedPreferences.getInstance();
    showInstructions = (prefs.getBool('seen') ?? false);
  }

  @override
  void initState() {
    checkFirstSeen();
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserData()
        .then((value) {
      _loggedIn =
          (Provider.of<UserProvider>(context, listen: false).id ?? 0) > 0;
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("Firebase onLaunch: $message");
        final type = message['data']['type'];
        int idSolicitud = message['data']['codigoSolicitud'];
        if (type != null) {
          if (type == "chat") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListaMensajesRoute()));
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("Firebase onResume: $message");
        final type = message['data']['type'];
        final idSolicitud = message['data']['codigoSolicitud'];

        if (type != null) {
          if (type == "chat") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListaMensajesRoute()));
          }
        }
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);

      if (_loggedIn) {
        HttpHelper().actualizarToken(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserProvider>(context).id == null) {
      _loggedIn = false;
    } else if (Provider.of<UserProvider>(context).rol == "vendedor") {
      _loggedIn = Provider.of<UserProvider>(context).id > 0;
      print("logueado: $_loggedIn");
      consultarSolicitudes(context);
    } else if (Provider.of<UserProvider>(context).rol == "administrador") {
      isAdministrador = true;
      _loggedIn = Provider.of<UserProvider>(context).id > 0;
      print("logueado: $_loggedIn");
      consultarSolicitudes(context);
    } else {
      print("no es usuario");
    }
    if (_loggedIn) {
      fetchTipoPlan();
    }

    return Stack(
      children: [
        !_loggedIn
            // ? formularioAfiliacion()
            ? LoginScreen()
            : SessionHelper().categorias == 0
                ? formularioAfiliacion()
                : Stack(
                    children: [
                      DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          appBar: AppBar(
                            title: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/nombre_transparencia.png",
                                  width: 200,
                                ),
                              ),
                            ),
                            backgroundColor: Color(0xFF7ED956),
                            actions: [
                              Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Badge(
                                    position:
                                        BadgePosition.topEnd(top: 5, end: 3),
                                    //position: BadgePosition.topRight(top: 7, right: 7),
                                    badgeContent: Text(
                                      Provider.of<NotificationsProvider>(
                                              context)
                                          .cantidad
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.notifications),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificacionesRoute(),
                                              ));
                                        }),
                                  ))
                            ],
                            bottom: PreferredSize(
                              preferredSize:
                                  Size.fromHeight(kToolbarHeight + 8),
                              child: Container(
                                height: 60,
                                color: Colors.white,
                                child: TabBar(
                                  indicatorColor: Color(0xFF537445),
                                  labelColor: Color(0xFF537445),
                                  tabs: [
                                    Tab(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.inbox,
                                            size: 23,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Flexible(
                                            child: Text("Recibidos"),
                                          )
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.send,
                                            size: 23,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Flexible(child: Text("Enviados"))
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            size: 23,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text("Papelera")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          drawer: FindooNavDrawer(),
                          body: TabBarView(
                            children: [
                              SolicitudesList(0),
                              SolicitudesList(1),
                              SolicitudesList(3),
                            ],
                          ),
                        ),
                      ),
                      showInstructions
                          ? Container(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                            )
                          : Container(),
                      showInstructions
                          ? Container(
                              child: Center(child: CarouselWithIndicatorDemo()),
                            )
                          : Container(),
                      showInstructions
                          ? Positioned(
                              top: 50,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showInstructions = false;
                                    prefs.setBool('seen', true);
                                  });
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.red),
                                      color: Colors.red),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
      ],
    );
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CarouselSlider(
        items: [1, 2, 3, 4, 5]
            .map((item) => Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: Image.asset(
                      "assets/instrucciones/$item.png",
                    ),
                  ),
                ))
            .toList(),
        options: CarouselOptions(
            autoPlay: false,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            height: MediaQuery.of(context).size.height - 200,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [1, 2, 3, 4, 5].map((id) {
          int index = [1, 2, 3, 4, 5].indexOf(id);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 255, 0, 0.9)
                  : Color.fromRGBO(255, 255, 255, 0.4),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}

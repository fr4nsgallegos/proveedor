import 'dart:async';

import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:findooproveedor/models/mensajes.dart';
import 'package:findooproveedor/models/ultimo_mensaje.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class ChatRoute extends StatefulWidget {
  UltimoMensaje ultimoMensaje;

  ChatRoute(this.ultimoMensaje);

  @override
  _ChatRouteState createState() => _ChatRouteState(ultimoMensaje);
}

class _ChatRouteState extends State<ChatRoute> {
  GlobalKey<ScaffoldState> scafoldkey = GlobalKey();
  PickedFile _imageFile1;
  int cantidadMensajes = 0;
  int cantidadMensajesPrev = 0;
  UltimoMensaje ultimoMensaje;
  final DateFormat hora = DateFormat('HH:mm dd/MM/yyyy');
  final DateFormat soloHora = DateFormat('HH:mm');
  final DateFormat solodia = DateFormat('dd/MM/yyyy');
  List<Mensaje> mensajes = [];
  List<Mensaje> mensajesFotos = [];
  ScrollController _scrollController;
  Timer t;
  dynamic _pickImageError;
  ImagePicker _picker = ImagePicker();

  TextEditingController mensajeController = TextEditingController();

  _ChatRouteState(this.ultimoMensaje);

  consultarSolicitudes() {
    if (t != null) t.cancel();
    t = Timer.periodic(Duration(seconds: 5), (timer) {
      cargarMensajes();
    });
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  Future cargarMensajes() async {
    List mensajesM = await HttpHelper().fetchMensajes(
        ultimoMensaje.receptor == SessionHelper().id
            ? ultimoMensaje.emisor.toString()
            : ultimoMensaje.receptor.toString());

    if (this.mounted) {
      setState(() {
        cantidadMensajesPrev = cantidadMensajes;
        mensajes = mensajesM;
        cantidadMensajes = mensajesM.length;
      });
    }

    print(mensajes.length);
  }

  @override
  void initState() {
    super.initState();
    cargarMensajes();
    consultarSolicitudes();
    _scrollController = new ScrollController();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cantidadMensajesPrev != cantidadMensajes) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
    return Scaffold(
      appBar: FindooAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: mensajes == null ? 0 : mensajes.length,
                      itemBuilder: (context, index) {
                        if (mensajes[index].receptor == SessionHelper().id) {
                          return buildMensaje(index, true);
                        }

                        return buildMensaje(index, false);
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade200),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: mensajeController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Hola ..."),
                                  onSubmitted: (value) async {
                                    Mensaje m = await HttpHelper()
                                        .enviarMensaje(
                                            ultimoMensaje.emisor ==
                                                    SessionHelper().id
                                                ? ultimoMensaje.receptor
                                                    .toString()
                                                : ultimoMensaje.emisor
                                                    .toString(),
                                            value);
                                    mensajeController.text = "";
                                    cargarMensajes();
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {
                                  _onImageButtonPressed(context: context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.lightGreen,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (mensajeController.text.length > 0) {
                              Mensaje m = await HttpHelper().enviarMensaje(
                                  ultimoMensaje.emisor == SessionHelper().id
                                      ? ultimoMensaje.receptor.toString()
                                      : ultimoMensaje.emisor.toString(),
                                  mensajeController.text);
                              if (_imageFile1 != null &&
                                  _imageFile1.path.length > 0) {
                                await HttpHelper().enviarAdjuntoMensajeImagen(
                                    _imageFile1, m.id.toString(), "1");
                              }
                              setState(() {
                                _imageFile1 = null;
                                mensajeController.text = "";
                              });
                              cargarMensajes();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.yellow.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        image: ultimoMensaje.fotoCliente == ''
                            ? new AssetImage("assets/images/usuarioSFoto.png")
                            : new NetworkImage(
                                "https://findooapp.com${ultimoMensaje.fotoCliente}"),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        alignment: Alignment.center,
                        child: Text(
                          ultimoMensaje.emisor != SessionHelper().id
                              ? ultimoMensaje.nombreEmisor
                              : ultimoMensaje.nombreReceptor,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        hora.format(ultimoMensaje.createdAt.toLocal()),
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
          ),
          _imageFile1 != null && _imageFile1.path.length > 0
              ? Positioned(
                  top: 0,
                  bottom: 70,
                  left: 0,
                  right: 0,
                  child: Image.file(
                    File(_imageFile1.path),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          _imageFile1 != null && _imageFile1.path.length > 0
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _imageFile1 = null;
                        });
                      }))
              : Container(),
        ],
      ),
    );
  }

  Padding buildMensaje(int index, bool recibido) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          (index >= 1 &&
                  mensajes[index].createdAt.toLocal().day !=
                      mensajes[index - 1].createdAt.toLocal().day)
              ? Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    solodia.format(mensajes[index].createdAt.toLocal()),
                    style: TextStyle(fontSize: 10),
                  ))
              : Container(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              !recibido ? Expanded(child: Container()) : Container(),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mensajes[index].adjunto.length > 0
                        ? SizedBox(
                            height: 240,
                            width: 240,
                            child: GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Hero(
                                  tag: mensajes[index].id,
                                  child: Image.network(
                                    "https://findooapp.com${mensajes[index].adjunto}",
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    //width: 240
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return detail(
                                          context,
                                          "https://findooapp.com${mensajes[index].adjunto}",
                                          mensajes[index].id);
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        /*Image.network(
                            mensajes[index].adjunto,
                            width: 240,
                          )*/
                        : Container(),
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                            new ClipboardData(text: mensajes[index].mensaje));
                        Flushbar(
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          message: "Mensaje copiado al portapapeles",
                          duration: Duration(seconds: 1),
                        )..show(context);
                      },
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: Text(mensajes[index].mensaje,
                            textAlign:
                                recibido ? TextAlign.left : TextAlign.right),
                      ),
                    ),
                    Text(
                      soloHora.format(mensajes[index].createdAt.toLocal()),
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: recibido
                      ? Colors.grey.shade100
                      : Colors.lightGreen.shade100,
                ),
              ),
              recibido ? Expanded(child: Container()) : Container(),
            ],
          ),
        ],
      ),
    );
  }

  void _onImageButtonPressed({BuildContext context}) async {
    await _displayPickImageDialog(context, (ImageSource source) async {
      try {
        final pickedFile =
            await _picker.getImage(source: source, imageQuality: 50);
        Mensaje m = await HttpHelper().enviarMensaje(
            ultimoMensaje.emisor == SessionHelper().id
                ? ultimoMensaje.receptor.toString()
                : ultimoMensaje.emisor.toString(),
            "");
        if (pickedFile != null && pickedFile.path.length > 0) {
          await HttpHelper()
              .enviarAdjuntoMensajeImagen(pickedFile, m.id.toString(), "1");
        }
        cargarMensajes();
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Selecciona una imagen desde:'),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCELAR'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('GALERÍA'),
                onPressed: () {
                  onPick(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: const Text('CÁMARA'),
                  onPressed: () {
                    onPick(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget detail(BuildContext context, String foto, int id) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        child: Stack(
          children: <Widget>[
            InteractiveViewer(
              child: Center(
                child: Hero(
                  tag: id,
                  child: PhotoView(
                    imageProvider: NetworkImage(foto),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 0,
              child: IconButton(
                color: Colors.red,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

typedef void OnPickImageCallback(ImageSource source);

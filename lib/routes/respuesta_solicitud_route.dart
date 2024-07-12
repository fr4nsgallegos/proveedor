import 'dart:io';

import 'package:findooproveedor/models/solicitud.dart';
import 'package:findooproveedor/routes/respuesta_solicitud_ver_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RespuestaSolicitudRoute extends StatefulWidget {
  final Solicitud solicitud;

  RespuestaSolicitudRoute(this.solicitud);

  @override
  _RespuestaSolicitudRouteState createState() =>
      _RespuestaSolicitudRouteState(solicitud);
}

class _RespuestaSolicitudRouteState extends State<RespuestaSolicitudRoute> {
  final Solicitud solicitud;
  final TextEditingController especificacionesController =
      TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController descuentoController = TextEditingController();

  PickedFile _imageFile1;
  PickedFile _imageFile2;
  PickedFile _imageFile3;
  dynamic _pickImageError;
  bool inAsyncCall = false;

  final ImagePicker _picker = ImagePicker();

  _RespuestaSolicitudRouteState(this.solicitud);

  @override
  void dispose() {
    especificacionesController.dispose();
    precioController.dispose();
    descuentoController.dispose();
    super.dispose();
  }

  Future<void> enviarRespuestaSolicitud() async {
    setState(() {
      inAsyncCall = true;
    });
    HttpHelper helper = HttpHelper();
    String cod = await helper.crearRespuestasolicitud(
        solicitud.id.toString(),
        especificacionesController.text,
        precioController.text,
        "1",
        descuentoController.text);

    await _subirImagenes(helper, cod);

    setState(() {
      inAsyncCall = false;
    });

    Navigator.pop(context, "Respuesta Enviada");
  }

  Future<void> _subirImagenes(HttpHelper helper, String cod) async {
    if (_imageFile1 != null && _imageFile1.path.isNotEmpty) {
      await helper.subirImagen(_imageFile1, cod);
    }
    if (_imageFile2 != null && _imageFile2.path.isNotEmpty) {
      await helper.subirImagen(_imageFile2, cod);
    }
    if (_imageFile3 != null && _imageFile3.path.isNotEmpty) {
      await helper.subirImagen(_imageFile3, cod);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        appBar: FindooAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.solicitud.productoPadres,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 8),
                Text(
                  widget.solicitud.nombreProducto,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 16),
                _buildTextLabel("Producto Solicitado:"),
                _buildTextContainer(widget.solicitud.productoSolicitado),
                SizedBox(height: 8),
                _buildTextLabel("Especificaciones / Comentarios:"),
                _buildMultilineTextField(especificacionesController,
                    "Descríbenos el producto que ofreces. Por ejemplo color, tamaño, marca, etc. Recuerda ser lo más específico posible."),
                SizedBox(height: 8),
                _buildTextLabel("Precio del Producto:"),
                _buildPriceTextField(),
                SizedBox(height: 8),
                _buildTextLabel("Descuento findoo aplicable:"),
                _buildDiscountTextField(),
                SizedBox(height: 8),
                _buildImageButtons(),
                SizedBox(height: 16),
                Center(
                  child: Text("Adjunta fotos o imágenes referenciales",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 24),
                Divider(),
                _buildResponseButtons(widget.solicitud.estadoRespuesta != 0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextContainer(String text) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
      child: Text(text),
    );
  }

  Widget _buildMultilineTextField(
      TextEditingController controller, String hintText) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildPriceTextField() {
    return Container(
      height: 55,
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Text(
            "S/",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Indícanos el precio del producto.",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountTextField() {
    return Container(
      height: 55,
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Text(
            "%",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 21),
          ),
          Expanded(
            child: TextField(
              controller: descuentoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Indícanos el porcentaje del descuento",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageButtons() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            _buildImageButton(1, _imageFile1),
            _buildImageButton(2, _imageFile2),
            _buildImageButton(3, _imageFile3),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton(int imageFileIndex, PickedFile imageFile) {
    return FlatButton(
      onPressed: () async {
        _onImageButtonPressed(context: context, imageFileIndex: imageFileIndex);
      },
      child: imageFile != null && imageFile.path.isNotEmpty
          ? Stack(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  File(imageFile.path),
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                child: SizedBox(
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        if (imageFileIndex == 1) {
                          _imageFile1 = null;
                        } else if (imageFileIndex == 2) {
                          _imageFile2 = null;
                        } else {
                          _imageFile3 = null;
                        }
                      });
                    },
                  ),
                ),
              )
            ])
          : Icon(Icons.camera_alt),
    );
  }

  void _onImageButtonPressed({BuildContext context, int imageFileIndex}) async {
    await _displayPickImageDialog(context, (ImageSource source) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          imageQuality: 25,
        );
        setState(() {
          if (imageFileIndex == 1) {
            _imageFile1 = pickedFile;
          } else if (imageFileIndex == 2) {
            _imageFile2 = pickedFile;
          } else {
            _imageFile3 = pickedFile;
          }
        });
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
                print("ELVISSSSS");

                onPick(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('CÁMARA'),
              onPressed: () {
                onPick(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponseButtons(bool isResponded) {
    return isResponded
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Solicitud ya respondida"),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RespuestaVerRoute(solicitud),
                    ),
                  );
                },
                child: Text(
                  "Ver Respuesta",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: enviarRespuestaSolicitud,
                child: Text(
                  "Responder",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ],
          );
  }
}

typedef void OnPickImageCallback(ImageSource source);

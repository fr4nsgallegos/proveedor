import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source) async {
    print("-------------------------------");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
      Permission.mediaLibrary,
    ].request();
    print("-------------------------------");

    try {
      PickedFile pickedFile =
          await _picker.getImage(source: ImageSource.gallery);
      print(pickedFile);
      if (pickedFile != null) {
        // Procesar la imagen seleccionada
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _requestPermission() async {
    if (await Permission.photos.request().isGranted) {
      // Permiso concedido
    } else {
      // Permiso denegado
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Imagen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _onImageButtonPressed(ImageSource.camera),
              child: Text('Tomar Foto'),
            ),
            ElevatedButton(
              onPressed: () => _onImageButtonPressed(ImageSource.gallery),
              child: Text('Seleccionar de Galería'),
            ),
          ],
        ),
      ),
    );
  }
}

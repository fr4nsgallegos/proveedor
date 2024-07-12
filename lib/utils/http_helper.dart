import 'dart:convert';

import 'package:findooproveedor/models/categoria.dart';
import 'package:findooproveedor/models/ciudad.dart';
import 'package:findooproveedor/models/cupon.dart';
import 'package:findooproveedor/models/empresa.dart';
import 'package:findooproveedor/models/mensajes.dart';
import 'package:findooproveedor/models/notificacion.dart';
import 'package:findooproveedor/models/respuesta_solicitud.dart';
import 'package:findooproveedor/models/solicitud.dart';
import 'package:findooproveedor/models/ultimo_mensaje.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

class HttpHelper {
  String urlBase = "https://findooapp.com/api/";

  Future<String> crearRespuestasolicitud(
    String solicitud,
    String especificaciones,
    String precio,
    String estado,
    String descuento,
  ) async {
    final response = await http.post(urlBase + "respuestaSolicitud/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "vendedor": SessionHelper().id.toString(),
      "solicitud": solicitud,
      "encabezado": especificaciones,
      "especificaciones": especificaciones,
      "estado": estado,
      "precio": precio,
      "descuento": descuento,
    });

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Algo salio mal");
      print(response.body);
      return null;
    }
    print(jsonDecode(response.body)["id"]);
    return jsonDecode(response.body)["id"].toString();
  }

  Future<String> eliminarRespuestasolicitud(String solicitud) async {
    final response = await http
        .delete(urlBase + "respuestaSolicitud/" + solicitud + "/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    });

    if (response.statusCode != 202 && response.statusCode != 204) {
      print("Algo salio mal");
      print(response.body);
      return null;
    }
    return solicitud;
  }

  Future<String> registrarVentaRespuestasolicitud(
    String solicitud,
  ) async {
    final response = await http
        .patch(urlBase + "respuestaSolicitud/" + solicitud + "/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "estado": "2",
    });

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 202) {
      print("Algo salio mal");
      print(response.body);
      return null;
    }
    print(jsonDecode(response.body)["id"]);
    return jsonDecode(response.body)["id"].toString();
  }

  Future<RespuestaSolicitud> obtenerRespuestasolicitud(String id) async {
    final response =
        await http.get((urlBase + "respuestaSolicitud/" + id + "/"), headers: {
      "Authorization": "JWT " + SessionHelper().token,
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      return RespuestaSolicitud.fromJson(responseJson);
    } else {
      return null;
    }
  }

  Future<Solicitud> obtenersolicitud(String id, String solicitud) async {
    final response = await http.get(
        (urlBase + "solicitudesProveedorDetalle/" + id + "/" + solicitud + "/"),
        headers: {
          "Authorization": "JWT " + SessionHelper().token,
          "Accept": "application/json",
          "content-type": "application/json",
          "charset": "utf-8"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Solicitud.fromJson((jsonDecode(utf8.decode(response.bodyBytes))));
    } else {
      return null;
    }
  }

  Future<Empresa> obtenerEmpresa(String id) async {
    final response =
        await http.get((urlBase + "proveedores/empresa/" + id + "/"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Empresa.fromJson((jsonDecode(utf8.decode(response.bodyBytes))));
      //var responseJson = json.decode(utf8.decode(response.bodyBytes));
      //return Empresa.fromJson(responseJson);
    } else {
      return null;
    }
  }

  Future<UltimoMensaje> getMensaje(String id) async {
    final response =
        await http.get((urlBase + "mensaje/" + id + "/"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return UltimoMensaje.fromJson(
          (jsonDecode(utf8.decode(response.bodyBytes))));
    } else {
      return null;
    }
  }

  Future<int> obtenerCantidadNotificaciones() async {
    final response = await http.get((urlBase +
        "notificaciones/contar/" +
        SessionHelper().id.toString() +
        "/"));

    if (response.statusCode == 200) {
      var responseJson = response.body;
      print(responseJson);
      if (responseJson.length > 0) {
        return int.parse(responseJson);
      }
      return 0;
    } else {
      return 0;
    }
  }

  Future<String> subirImagen(PickedFile imagen, String cod) async {
    print("subiendo");
    final url = Uri.parse(urlBase + "imagen_respuesta_solicitud/");
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    imageUploadRequest.headers.addAll({
      "Authorization": "JWT " + SessionHelper().token,
    });

    final file = await http.MultipartFile.fromPath('image', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['respuesta_solicitud'] = cod;

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      print("Algo salio mal");
      return null;
    }
    print(resp.body);
    return resp.body;
  }

  Future<List<Notificacion>> fetchNotificaciones() async {
    final response = await http.get(
        (urlBase + "notificaciones/listar/${SessionHelper().id}/"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "charset": "utf-8"
        });
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      List<Notificacion> notificaciones =
          responseJson.map((m) => new Notificacion.fromJson(m)).toList();

      return notificaciones;
    } else {
      return null;
    }
  }

  Future<List<UltimoMensaje>> fetchUltimosMensajes() async {
    final response = await http
        .get((urlBase + "mensaje/listar/${SessionHelper().id}/"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      List<UltimoMensaje> mensajes =
          responseJson.map((m) => new UltimoMensaje.fromJson(m)).toList();

      return mensajes;
    } else {
      return null;
    }
  }

  Future<List<Mensaje>> fetchMensajes(String id) async {
    final response =
        await http.get((urlBase + "mensaje/listar/${SessionHelper().id}/$id/"));
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      List<Mensaje> mensajes =
          responseJson.map((m) => new Mensaje.fromJson(m)).toList();

      return mensajes;
    } else {
      return null;
    }
  }

  Future<Mensaje> enviarMensaje(String receptor, String mensaje) async {
    final response = await http.post(urlBase + "mensaje/envio/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "emisor": SessionHelper().id.toString(),
      "receptor": receptor,
      "mensaje": mensaje,
      "ubicacion": "-",
    });
    print(response.bodyBytes);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      Mensaje mensaje = Mensaje.fromJson(responseJson);
      print("Exito");
      return mensaje;
    }
    return null;
  }

  Future<String> enviarAdjuntoMensajeImagen(
      PickedFile imagen, String mensaje, String tipo) async {
    print("subiendo Adjunto");
    final url = Uri.parse(urlBase + "mensaje/adjunto/");
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    imageUploadRequest.headers.addAll({
      "Authorization": "JWT " + SessionHelper().token,
    });

    final file = await http.MultipartFile.fromPath('archivo', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['mensaje'] = mensaje;
    imageUploadRequest.fields['tipo'] = tipo;

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      print("Algo salio mal");
      return null;
    }
    print(resp.body);
    return resp.body;
  }

  Future contactanos(String mensaje) async {
    final response = await http.post(urlBase + "contactanos/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "id_user": SessionHelper().id.toString(),
      "mensaje": mensaje,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito");
    }
  }

  Future actualizarToken(String token) async {
    final response = await http.post(urlBase + "usuarios/perfil/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "idUser": SessionHelper().id.toString(),
      "token": token,
      "email": SessionHelper().email,
      "first_name": SessionHelper().first_name,
      "last_name": SessionHelper().last_name,
    });
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exitosssssssssss");
    }
  }

  Future verificarCupon(String cuponId) async {
    final response = await http.post(urlBase + "cuponvalidar/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "usuario_id": SessionHelper().id.toString(),
      "cupon_id": cuponId,
    });
    print(response.body);
    try {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson["success"]) {
        return responseJson["success"];
      }
    } on Exception {
      return false;
    }
    return false;
  }

  Future canjearCupon(String cuponId) async {
    final response = await http.post(urlBase + "cuponcanjear/", headers: {
      "Authorization": "JWT " + SessionHelper().token,
    }, body: {
      "cupon_id": cuponId
    });
    print(response.body);
    try {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson["id"] > 0) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }

  Future<List<Ciudad>> getCiudades() async {
    final response = await http.get((urlBase + "ciudades/"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      List<Ciudad> ciudades =
          responseJson.map((m) => new Ciudad.fromJson(m)).toList();

      return ciudades;
    } else {
      return null;
    }
  }

  Future<Cupon> getCupon(String id) async {
    final response =
        await http.get((urlBase + "EliminarCupon/" + id + "/"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Cupon.fromJson((jsonDecode(utf8.decode(response.bodyBytes))));
      //var responseJson = json.decode(utf8.decode(response.bodyBytes));
      //return Empresa.fromJson(responseJson);
    } else {
      return null;
    }
  }

  Future postRegitroForm(
      String razonSocial,
      String ruc,
      String codPromocion,
      String razonComercial,
      String dni,
      String telefono,
      String email,
      String nombre,
      List<int> categorias) async {
    final response = await http.post(urlBase + "proveedor/afiliacion/",
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "razon_social": razonSocial,
          "ruc": ruc,
          "promocion": codPromocion,
          "ruc_comercial": razonComercial,
          "dni": dni,
          "telefono": telefono,
          "email": email,
          "nombre": nombre,
          "categorias": categorias,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      print("Se registró correctamente");
    } else {
      print(response.statusCode);
      print("error");
    }
  }

  Future postRegitroForm2(
      String razonSocial,
      String razonComercial,
      String ruc,
      String telefono,
      String correo,
      String direccion,
      String ubicacionMaps,
      String horario,
      String pago,
      String vendedor1,
      String vendedor2,
      String vendedor3,
      String administrador,
      List<int> categorias) async {
    final response = await http.post(urlBase + "proveedor/afiliacion/App/",
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "razon_social": razonSocial,
          "razonComercial": razonComercial,
          "ruc": ruc,
          "telefono": telefono,
          "correo": correo,
          "direccion": direccion,
          "ubicacionMaps": ubicacionMaps,
          "horario": horario,
          "pago": pago,
          "vendedor1": vendedor1,
          "vendedor2": vendedor2,
          "vendedor3": vendedor3,
          "administrador": administrador,
          "categorias": categorias,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      print("Se registró correctamente el form 2");
    } else {
      print(response.statusCode);
      print("error");
    }
  }

  Future postCambiarContrasena(
    int id,
    String contrasena,
  ) async {
    final response = await http.put(urlBase + "cambiarpasswdId/",
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "id": id,
          "password": contrasena,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      print("Se ha actualizado la contraseña");
    } else {
      print(response.statusCode);
      print("error");
    }
  }

  Future<List<Categoria>> getCategorias() async {
    final response = await http.get((urlBase + "categorias/"));
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      List<Categoria> categorias =
          responseJson.map((m) => new Categoria.fromJson(m)).toList();

      return categorias;
    } else {
      return null;
    }
  }
}

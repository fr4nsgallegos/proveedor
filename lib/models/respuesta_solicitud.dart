// To parse this JSON data, do
//
//     final respuestaSolicitud = respuestaSolicitudFromJson(jsonString);

import 'dart:convert';

RespuestaSolicitud respuestaSolicitudFromJson(String str) =>
    RespuestaSolicitud.fromJson(json.decode(str));

String respuestaSolicitudToJson(RespuestaSolicitud data) =>
    json.encode(data.toJson());

class RespuestaSolicitud {
  RespuestaSolicitud({
    this.id,
    this.vendedor,
    this.solicitud,
    this.encabezado,
    this.especificaciones,
    this.precio,
    this.nombreProducto,
    this.vendedorNombre,
    this.empresaNombre,
    this.empresaValoracion,
    this.empresaLogo,
    this.createdAt,
    this.estado,
    this.imagesRespuestaSolicitud,
    this.descuento,
  });

  int id;
  int vendedor;
  int solicitud;
  String encabezado;
  String especificaciones;
  double precio;
  String nombreProducto;
  String vendedorNombre;
  String empresaNombre;
  int empresaValoracion;
  String empresaLogo;
  DateTime createdAt;
  int estado;
  List<ImagesRespuestaSolicitud> imagesRespuestaSolicitud;
  double descuento;

  factory RespuestaSolicitud.fromJson(Map<String, dynamic> json) =>
      RespuestaSolicitud(
        id: json["id"],
        vendedor: json["vendedor"],
        solicitud: json["solicitud"],
        encabezado: json["encabezado"],
        especificaciones: json["especificaciones"],
        precio: json["precio"] * 1.0,
        nombreProducto: json["nombre_producto"],
        vendedorNombre: json["vendedor_nombre"],
        empresaNombre: json["empresa_nombre"],
        empresaValoracion: json["empresa_valoracion"],
        empresaLogo: json["empresa_logo"],
        createdAt: DateTime.parse(json["created_at"]),
        estado: json["estado"],
        imagesRespuestaSolicitud: List<ImagesRespuestaSolicitud>.from(
            json["images_respuesta_solicitud"]
                .map((x) => ImagesRespuestaSolicitud.fromJson(x))),
        descuento: json["descuento"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendedor": vendedor,
        "solicitud": solicitud,
        "encabezado": encabezado,
        "especificaciones": especificaciones,
        "precio": precio,
        "nombre_producto": nombreProducto,
        "vendedor_nombre": vendedorNombre,
        "empresa_nombre": empresaNombre,
        "empresa_valoracion": empresaValoracion,
        "empresa_logo": empresaLogo,
        "created_at": createdAt.toIso8601String(),
        "estado": estado,
        "images_respuesta_solicitud":
            List<dynamic>.from(imagesRespuestaSolicitud.map((x) => x.toJson())),
        "descuento": descuento,
      };
}

class ImagesRespuestaSolicitud {
  ImagesRespuestaSolicitud({
    this.image,
    this.respuestaSolicitud,
  });

  String image;
  int respuestaSolicitud;

  factory ImagesRespuestaSolicitud.fromJson(Map<String, dynamic> json) =>
      ImagesRespuestaSolicitud(
        image: json["image"],
        respuestaSolicitud: json["respuesta_solicitud"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "respuesta_solicitud": respuestaSolicitud,
      };
}

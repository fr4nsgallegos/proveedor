// To parse this JSON data, do
//
//     final ultimoMensaje = ultimoMensajeFromJson(jsonString);

import 'dart:convert';

UltimoMensaje ultimoMensajeFromJson(String str) =>
    UltimoMensaje.fromJson(json.decode(str));

String ultimoMensajeToJson(UltimoMensaje data) => json.encode(data.toJson());

class UltimoMensaje {
  UltimoMensaje({
    this.id,
    this.emisor,
    this.receptor,
    this.mensaje,
    this.ubicacion,
    this.leido,
    this.nombreEmisor,
    this.nombreReceptor,
    this.createdAt,
    this.foto,
    this.fotoCliente,
    this.vendedor,
    this.proveedor,
  });

  int id;
  int emisor;
  int receptor;
  String mensaje;
  String ubicacion;
  bool leido;
  String nombreEmisor;
  String nombreReceptor;
  DateTime createdAt;
  String foto;
  String fotoCliente;
  String vendedor;
  Proveedor proveedor;

  factory UltimoMensaje.fromJson(Map<String, dynamic> json) => UltimoMensaje(
        id: json["id"],
        emisor: json["emisor"],
        receptor: json["receptor"],
        mensaje: json["mensaje"],
        ubicacion: json["ubicacion"],
        leido: json["leido"],
        nombreEmisor: json["nombre_emisor"],
        nombreReceptor: json["nombre_receptor"],
        createdAt: DateTime.parse(json["created_at"]),
        foto: json["foto"],
        fotoCliente: json["foto_cliente"],
        vendedor: json["vendedor"],
        proveedor: Proveedor.fromJson(json["proveedor"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "emisor": emisor,
        "receptor": receptor,
        "mensaje": mensaje,
        "ubicacion": ubicacion,
        "leido": leido,
        "nombre_emisor": nombreEmisor,
        "nombre_receptor": nombreReceptor,
        "created_at": createdAt.toIso8601String(),
        "foto": foto,
        "foto_cliente": fotoCliente,
        "vendedor": vendedor,
        "proveedor": proveedor.toJson(),
      };
}

class Proveedor {
  Proveedor({
    this.id,
    this.razonSocial,
    this.ruc,
    this.telefono,
    this.direccion,
    this.googleMapUbicacion,
    this.horarioAtencion,
    this.mediosPago,
    this.imagen,
    this.valoracion,
  });

  int id;
  String razonSocial;
  String ruc;
  dynamic telefono;
  String direccion;
  String googleMapUbicacion;
  dynamic horarioAtencion;
  dynamic mediosPago;
  String imagen;
  int valoracion;

  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json["id"],
        razonSocial: json["razon_social"],
        ruc: json["ruc"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        googleMapUbicacion: json["google_map_ubicacion"],
        horarioAtencion: json["horario_atencion"],
        mediosPago: json["medios_pago"],
        imagen: json["imagen"],
        valoracion: json["valoracion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "razon_social": razonSocial,
        "ruc": ruc,
        "telefono": telefono,
        "direccion": direccion,
        "google_map_ubicacion": googleMapUbicacion,
        "horario_atencion": horarioAtencion,
        "medios_pago": mediosPago,
        "imagen": imagen,
        "valoracion": valoracion,
      };
}

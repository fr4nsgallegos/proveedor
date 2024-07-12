// To parse this JSON data, do
//
//     final mensaje = mensajeFromJson(jsonString);

import 'dart:convert';

Mensaje mensajeFromJson(String str) => Mensaje.fromJson(json.decode(str));

String mensajeToJson(Mensaje data) => json.encode(data.toJson());

class Mensaje {
  Mensaje({
    this.id,
    this.emisor,
    this.receptor,
    this.mensaje,
    this.ubicacion,
    this.leido,
    this.adjunto,
    this.createdAt,
  });

  int id;
  int emisor;
  int receptor;
  String mensaje;
  String ubicacion;
  bool leido;
  String adjunto;
  DateTime createdAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        id: json["id"],
        emisor: json["emisor"],
        receptor: json["receptor"],
        mensaje: json["mensaje"],
        ubicacion: json["ubicacion"],
        leido: json["leido"],
        adjunto: json["adjunto"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "emisor": emisor,
        "receptor": receptor,
        "mensaje": mensaje,
        "ubicacion": ubicacion,
        "leido": leido,
        "adjunto": adjunto,
        "created_at": createdAt.toIso8601String(),
      };
}

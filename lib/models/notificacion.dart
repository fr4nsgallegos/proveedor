// To parse this JSON data, do
//
//     final notificacion = notificacionFromJson(jsonString);

import 'dart:convert';

Notificacion notificacionFromJson(String str) =>
    Notificacion.fromJson(json.decode(str));

String notificacionToJson(Notificacion data) => json.encode(data.toJson());

class Notificacion {
  Notificacion({
    this.texto,
    this.leido,
    this.emisor,
    this.tipo,
    this.codigo,
    this.createdAt,
    this.imagen,
    this.id,
  });

  String texto;
  bool leido;
  int emisor;
  int tipo;
  int codigo;
  DateTime createdAt;
  String imagen;
  int id;

  factory Notificacion.fromJson(Map<String, dynamic> json) => Notificacion(
        texto: json["texto"],
        leido: json["leido"],
        emisor: json["emisor"],
        tipo: json["tipo"],
        codigo: json["codigo"],
        createdAt: DateTime.parse(json["created_at"]),
        imagen: json["imagen"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "texto": texto,
        "leido": leido,
        "emisor": emisor,
        "tipo": tipo,
        "codigo": codigo,
        "created_at": createdAt.toIso8601String(),
        "imagen": imagen,
        "id": id,
      };
}

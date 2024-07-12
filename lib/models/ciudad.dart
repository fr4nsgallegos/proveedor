// To parse this JSON data, do
//
//     final ciudad = ciudadFromJson(jsonString);

import 'dart:convert';

Ciudad ciudadFromJson(String str) => Ciudad.fromJson(json.decode(str));

String ciudadToJson(Ciudad data) => json.encode(data.toJson());

class Ciudad {
  Ciudad({
    this.id,
    this.nombre,
  });

  int id;
  String nombre;

  factory Ciudad.fromJson(Map<String, dynamic> json) => Ciudad(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}

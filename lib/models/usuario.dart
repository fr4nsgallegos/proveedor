// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.id,
    this.ciudad,
    this.firstName,
    this.lastName,
    this.email,
    this.imagen,
    this.rol,
    this.puntaje,
    this.codigoPromocion,
    this.categorias,
  });

  int id;
  int ciudad;
  String firstName;
  String lastName;
  String email;
  String imagen;
  String rol;
  int puntaje;
  String codigoPromocion;
  int categorias;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        ciudad: json["ciudad"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        imagen: json["imagen"],
        rol: json["rol"],
        puntaje: json["puntaje"],
        codigoPromocion: json["codigo_promocion"],
        categorias: json["categorias"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ciudad": ciudad,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "imagen": imagen,
        "rol": rol,
        "puntaje": puntaje,
        "codigo_promocion": codigoPromocion,
        "categorias": categorias,
      };
}

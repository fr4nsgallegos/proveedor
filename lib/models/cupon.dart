import 'dart:convert';

Cupon cuponFromJson(String str) => Cupon.fromJson(json.decode(str));

String cuponToJson(Cupon data) => json.encode(data.toJson());

class Cupon {
  Cupon({
    this.id,
    this.usuario,
    this.empresa,
    this.usado,
    this.empresaNombre,
    this.valor,
    this.clienteNombre,
  });

  int id;
  int usuario;
  int empresa;
  bool usado;
  String empresaNombre;
  double valor;
  String clienteNombre;

  factory Cupon.fromJson(Map<String, dynamic> json) => Cupon(
        id: json["id"],
        usuario: json["usuario"],
        empresa: json["empresa"],
        usado: json["usado"],
        empresaNombre: json["empresa_nombre"],
        valor: json["valor"],
        clienteNombre: json["cliente_nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "empresa": empresa,
        "usado": usado,
        "empresa_nombre": empresaNombre,
        "valor": valor,
        "cliente_nombre": clienteNombre,
      };
}

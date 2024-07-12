import 'dart:convert';

Categoria categoriaFromJson(String str) => Categoria.fromJson(json.decode(str));

String categoriaToJson(Categoria data) => json.encode(data.toJson());

class Categoria {
  Categoria({
    this.id,
    this.descripcion,
    this.imagenBanner,
    this.imagenCuadrada,
    this.cantHijos,
    this.padre,
    this.nivel,
    this.redColor,
    this.greenColor,
    this.blueColor,
    this.value = false,
  });

  int id;
  String descripcion;
  String imagenBanner;
  String imagenCuadrada;
  int cantHijos;
  int padre;
  int nivel;
  int redColor;
  int greenColor;
  int blueColor;
  bool value;

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        descripcion: json["descripcion"],
        imagenBanner: json["imagen_banner"],
        imagenCuadrada: json["imagen_cuadrada"],
        cantHijos: json["cant_hijos"],
        padre: json["padre"],
        nivel: json["nivel"],
        redColor: json["red_color"],
        greenColor: json["green_color"],
        blueColor: json["blue_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "imagen_banner": imagenBanner,
        "imagen_cuadrada": imagenCuadrada,
        "cant_hijos": cantHijos,
        "padre": padre,
        "nivel": nivel,
        "red_color": redColor,
        "green_color": greenColor,
        "blue_color": blueColor,
      };
}

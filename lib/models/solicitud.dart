class Solicitud {
  int id;
  int comprador;
  int producto;
  String especificaciones;
  double precioMaximo;
  int estado;
  int estadoRespuesta;
  String createdAt;
  List<Images> images;
  int idAbuelo;
  String nombreCompleto;
  String nombreProducto;
  String productoSolicitado;
  String productoPadres;
  String compradorNombre;
  String productoImagen;

  Solicitud(
      {this.id,
      this.comprador,
      this.producto,
      this.especificaciones,
      this.precioMaximo,
      this.estado,
      this.estadoRespuesta,
      this.createdAt,
      this.images,
      this.idAbuelo,
      this.nombreCompleto,
      this.nombreProducto,
      this.productoSolicitado,
      this.productoPadres,
      this.compradorNombre,
      this.productoImagen});

  Solicitud.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comprador = json['comprador'];
    producto = json['producto'];
    especificaciones = json['especificaciones'];
    precioMaximo = json['precio_maximo'];
    estado = json['estado'];
    estadoRespuesta = json['estado_respuesta'];
    createdAt = json['created_at'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    idAbuelo = json['id_abuelo'];
    nombreCompleto = json['nombre_completo'];
    nombreProducto = json['nombre_producto'];
    productoSolicitado = json['nombreProducto'];
    productoPadres = json['producto_padres'];
    compradorNombre = json['comprador_nombre'];
    productoImagen = json['producto_imagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comprador'] = this.comprador;
    data['producto'] = this.producto;
    data['especificaciones'] = this.especificaciones;
    data['precio_maximo'] = this.precioMaximo;
    data['estado'] = this.estado;
    data['estado_respuesta'] = this.estadoRespuesta;
    data['created_at'] = this.createdAt;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['id_abuelo'] = this.idAbuelo;
    data['nombre_completo'] = this.nombreCompleto;
    data['nombre_producto'] = this.nombreProducto;
    data['nombreProducto'] = this.productoSolicitado;
    data['producto_padres'] = this.productoPadres;
    data['comprador_nombre'] = this.compradorNombre;
    data['producto_imagen'] = this.productoImagen;
    return data;
  }
}

class Images {
  int id;
  String image;
  int solicitud;

  Images({this.id, this.image, this.solicitud});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    solicitud = json['solicitud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['solicitud'] = this.solicitud;
    return data;
  }
}

class Empresa {
  Empresa({
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
    this.plan,
    this.fechaVencimiento,
    this.ciudad,
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
  int plan;
  dynamic fechaVencimiento;
  int ciudad;

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
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
        plan: json["plan"],
        fechaVencimiento: json["fecha_vencimiento"],
        ciudad: json["ciudad"],
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
        "plan": plan,
        "fecha_vencimiento": fechaVencimiento,
        "ciudad": ciudad,
      };
}

import 'package:findooproveedor/models/respuesta_solicitud.dart';
import 'package:findooproveedor/models/solicitud.dart';
import 'package:findooproveedor/routes/solicitud_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class RespuestaVerRoute extends StatelessWidget {
  Solicitud solicitud;
  bool createdFromMain = false;
  RespuestaSolicitud respuestaSolicitud;

  RespuestaVerRoute(this.solicitud, {this.createdFromMain});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: FindooAppBar(),
      body: FutureBuilder(
        future: HttpHelper()
            .obtenerRespuestasolicitud(solicitud.estadoRespuesta.toString()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            respuestaSolicitud = snapshot.data;
            return Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solicitud.productoPadres,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    solicitud.nombreProducto,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Hola soy  ',
                      style: Theme.of(context).textTheme.bodyText2,
                      children: <TextSpan>[
                        TextSpan(
                            text: respuestaSolicitud.vendedorNombre,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: " y trabajo en ",
                        ),
                        TextSpan(
                            text: respuestaSolicitud.empresaNombre,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      text:
                          "Este es el producto que tenemos según la búsqueda que realizaste: ",
                      style: Theme.of(context).textTheme.bodyText2,
                      children: <TextSpan>[
                        TextSpan(
                            text: respuestaSolicitud.nombreProducto,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Con las siguientes especificaciones:"),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(respuestaSolicitud.especificaciones),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "Estas son algunas imágenes referenciales del producto que buscas:"),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            respuestaSolicitud.imagesRespuestaSolicitud.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: () {
                              open(context, index);
                            },
                            child: Image.network(
                              respuestaSolicitud
                                  .imagesRespuestaSolicitud[index].image,
                              height: 130,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("El precio del producto es:"),
                      Text(
                        "S/ " + respuestaSolicitud.precio.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  respuestaSolicitud.descuento == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Descuento findoo aplicable:"),
                              Text(
                                "S/ " +
                                    (respuestaSolicitud.precio *
                                            respuestaSolicitud.descuento /
                                            100)
                                        .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Estamos listos para atenderte.",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (createdFromMain != null && createdFromMain) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SolicitudRoute(solicitud),
                            ));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Ver Solicitud",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: respuestaSolicitud.imagesRespuestaSolicitud,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<ImagesRespuestaSolicitud> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Imagen ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ImagesRespuestaSolicitud item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.image),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.respuestaSolicitud),
    );
  }
}

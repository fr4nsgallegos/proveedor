import 'package:findooproveedor/models/solicitud.dart';
import 'package:findooproveedor/routes/respuesta_solicitud_route.dart';
import 'package:findooproveedor/routes/respuesta_solicitud_ver_route.dart';
import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/utils/session_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SolicitudRoute extends StatelessWidget {
  Solicitud solicitud;
  bool createdFromMain = false;

  SolicitudRoute(this.solicitud, {this.createdFromMain});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: FindooAppBar(),
      body: Padding(
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
                      text: solicitud.compradorNombre,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                text: "Estoy buscando este producto: ",
                style: Theme.of(context).textTheme.bodyText2,
                children: <TextSpan>[
                  TextSpan(
                      text: solicitud.productoSolicitado,
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
                child: Text(solicitud.especificaciones),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                "Estas son algunas imágenes referenciales del producto que busco:"),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: solicitud.images.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () {
                        open(context, index);
                      },
                      child: Image.network(
                        solicitud.images[index].image,
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
            Text("Muchas Gracias",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 8,
            ),
            Text("Quedo a la espera de tu respuesta."),
            SizedBox(
              height: 24,
            ),
            Divider(),
            buildBotonesRespuesta(solicitud.estadoRespuesta != 0, context)
          ],
        ),
      ),
    );
  }

  Row buildBotonesRespuesta(bool respondido, BuildContext context) {
    if (respondido) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Solicitud ya respondida"),
          FlatButton(
            onPressed: () {
              if (createdFromMain != null && createdFromMain) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RespuestaVerRoute(solicitud),
                    ));
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              "Ver Respuesta",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ],
      );
    } else
      return SessionHelper().rol == "administrador"
          ? Row()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () async {
                    HttpHelper helper = HttpHelper();
                    await helper.crearRespuestasolicitud(
                      solicitud.id.toString(),
                      "Descartado",
                      "0",
                      "3",
                      "0",
                    );
                    Navigator.pop(context, "Solicitud descartada");
                  },
                  child: Text(
                    "Descartar",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    final res =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RespuestaSolicitudRoute(solicitud),
                    ));
                    if (res != null) {
                      Navigator.pop(context, "Respuesta Enviada");
                    }
                  },
                  child: Text(
                    "Responder",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ],
            );
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: solicitud.images,
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
  final List<Images> galleryItems;
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
            ),
            Positioned(
              top: 50,
              right: 0,
              child: IconButton(
                color: Colors.red,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Images item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage("https://findooapp.com${item.image}"),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}

import 'package:findooproveedor/commons/consts.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';

class TerminosCondicionesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FindooAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                Constantes.terminosCondiciones,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

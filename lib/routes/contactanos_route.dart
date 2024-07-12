import 'package:findooproveedor/utils/http_helper.dart';
import 'package:findooproveedor/widgets/findoo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Contactanos extends StatefulWidget {
  @override
  _ContactanosState createState() => _ContactanosState();
}

class _ContactanosState extends State<Contactanos> {
  GlobalKey<ScaffoldState> scafoldkey = GlobalKey();
  bool isAsyncCall = false;
  TextEditingController mensajeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      appBar: FindooAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: isAsyncCall,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Comunícate con findoo",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 35,
              ),
              Expanded(
                child: TextField(
                  controller: mensajeController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 25,
                  decoration: InputDecoration(
                    hintText: "Dinos como podemos ayudarte",
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  setState(() {
                    isAsyncCall = true;
                  });
                  await HttpHelper().contactanos(mensajeController.text);
                  scafoldkey.currentState.showSnackBar(
                      SnackBar(content: Text("Mensaje enviado exitosamente")));
                  setState(() {
                    mensajeController.text = "";
                    isAsyncCall = false;
                  });
                },
                child: Text(
                  "Enviar",
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
        ),
      ),
    );
  }
}

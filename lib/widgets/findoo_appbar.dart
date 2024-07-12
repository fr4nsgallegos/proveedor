import 'package:badges/badges.dart';
import 'package:findooproveedor/providers/notifications_provider.dart';
import 'package:findooproveedor/routes/notificaciones_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindooAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool disableNotificacionButton;
  FindooAppBar({this.disableNotificacionButton = false});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Center(
          child: Image.asset(
            "assets/images/nombre_transparencia.png",
            width: 200,
          ),
        ),
      ),
      backgroundColor: Color(0xFF7ED956),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Provider.of<NotificationsProvider>(context).cantidad > 0
              ? Badge(
                  position: BadgePosition.topEnd(top: 5, end: 3),
                  //position: BadgePosition.topRight(top: 7, right: 7),
                  badgeContent: Text(
                    Provider.of<NotificationsProvider>(context)
                        .cantidad
                        .toString(),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        if (!disableNotificacionButton) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificacionesRoute(),
                              ));
                        }
                      }),
                )
              : IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    if (!disableNotificacionButton) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificacionesRoute(),
                          ));
                    }
                  }),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

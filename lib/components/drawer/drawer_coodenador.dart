import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/style/images.dart';
import '../../screens/configuracoes/configuracoes.dart';
import '../../screens/configuracoes/meuPerfil.dart';
import '../../screens/professor/filasProfessor.dart';
import '../../screens/professor/minhasReservas.dart';
import '../../style/colors.dart';
import '../../style/drawerTexts.dart';
import '../navegacao.dart';

class DrawerCoodenador extends StatefulWidget {
  const DrawerCoodenador({super.key});

  @override
  State<DrawerCoodenador> createState() => _DrawerCoodenadorState();
}

class _DrawerCoodenadorState extends State<DrawerCoodenador> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: branco,
      width: 250,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: azulEscuro,
              border: Border.all(width: 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              width: 240,
              child: GestureDetector(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(Perfil),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lorem Ipsum',
                            style: TextStyleUsuario.usuario,
                            overflow: TextOverflow.ellipsis,
                          ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                          Text(
                            'Coordenador',
                            style: TextStyleCargo.cargo,
                            overflow: TextOverflow.ellipsis,
                          ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Meuperfil()),
                  );
                },
              ),
            ),
          ),
          Navegacao(
            Icon(Icons.checklist_outlined, size: 25),
            "Reservas",
            context,
            Minhasreservas(),
          ),
          Navegacao(
            Icon(Icons.person_add_alt_1_sharp, size: 25),
            "Filas de espera",
            context,
            Filasprofessor(),
          ),
          Navegacao(
            Icon(Icons.notification_add_sharp, size: 25),
            "Notificações",
            context,
            Filasprofessor(),
          ),
          Navegacao(
            Icon(Icons.settings, size: 25),
            "Configurações",
            context,
            Configuracoes(),
          ),
          Navegacao(
            Icon(Icons.exit_to_app_sharp, size: 25),
            "Sair",
            context,
            TelaLogin(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../wicss.dart';
import 'pantalla1/inicio.dart';
import 'pantalla2/horario.dart';
import 'pantalla3/tareas.dart';
import 'pantalla4/logros.dart';
import 'pantalla5/configuracion.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final List<Widget> pas = const [
    PantallaInicio(), PantallaHorario(), PantallaTareas(),
    PantallaLogros(), PantallaConfig(),
  ];

  late final PageController pgC;
  int idx = 0;

  @override
  void initState() {
    super.initState();
    pgC = PageController(initialPage: idx);
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    backgroundColor: AppCSS.bg,
    body: PageView(
      controller: pgC,
      onPageChanged: (i) => setState(() => idx = i),
      children: pas,
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: idx,
      onTap: (i) {
        setState(() => idx = i);
        pgC.animateToPage(i, duration: AppCSS.trM, curve: Curves.easeInOut);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppCSS.F,
      selectedItemColor: AppCSS.mco,
      unselectedItemColor: AppCSS.grs,
      selectedLabelStyle: AppEs.iSM.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppEs.tSM,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Horario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          activeIcon: Icon(Icons.check_circle),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          activeIcon: Icon(Icons.emoji_events),
          label: 'Logros',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
    ),
  );

  @override
  void dispose() {
    pgC.dispose();
    super.dispose();
  }
}
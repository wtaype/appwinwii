import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../../wii.dart';

class PantallaAcerca extends StatelessWidget {
  const PantallaAcerca({super.key});

  Future<void> _url(String u) async {
    final uri = Uri.parse(u);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    backgroundColor: AppCSS.bg,
    appBar: AppBar(
      title: Text('Acerca de', style: AppEs.btn),
      backgroundColor: AppCSS.mco,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppCSS.whi),
        onPressed: () => Navigator.pop(ctx),
      ),
    ),
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(children: [
        AppCSS.gm,
        // 🏷️ Logo _______
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppCSS.whi,
            boxShadow: [BoxShadow(color: AppCSS.mco.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)],
          ),
          child: ClipOval(child: AppCSS.logo),
        ),
        AppCSS.gm,
        gdTexto(wii.app),
        AppCSS.gs,
        Text(wii.version, style: AppEs.lbl),
        AppCSS.gm,

        // 📖 Contenido _______
        Glass(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _p('${wii.app} es un planificador semanal inteligente diseñado para organizar tu horario, '
              'tareas, notas y logros de forma profesional. Todo en un solo lugar, 100% gratis.'),
          _p('Con ${wii.app} puedes visualizar tu semana completa, gestionar pendientes con un sistema '
              'Kanban, celebrar tus logros y mantener el control de tu tiempo como un verdadero profesional.'),
          _p('Diseñado con mucho cariño para estudiantes, profesionales y cualquier persona que quiera '
              'aprovechar al máximo cada día de su semana.'),
        ])),
        AppCSS.gm,

        // 🔗 Redes _______
        Glass(child: Column(children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppCSS.gSky,
                borderRadius: BorderRadius.circular(AppCSS.rM),
              ),
              child: const Icon(Icons.language, color: AppCSS.whi, size: 22),
            ),
            AppCSS.ghm,
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Portafolio web', style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
              Text(wii.link, style: AppEs.sm.copyWith(color: AppCSS.mco)),
            ])),
            IconButton(
              icon: const Icon(Icons.open_in_new, color: AppCSS.mco, size: 18),
              onPressed: () => _url(wii.link),
            ),
          ]),
        ])),
        AppCSS.gm,

        // ✍️ Firma _______
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppCSS.l),
          decoration: BoxDecoration(
            gradient: AppCSS.gSky,
            borderRadius: BorderRadius.circular(AppCSS.rXL),
          ),
          child: Column(children: [
            const Icon(Icons.favorite, size: 32, color: AppCSS.whi),
            AppCSS.gs,
            Text('Creado con ❤️', style: AppEs.h3.copyWith(color: AppCSS.whi)),
            AppCSS.gs,
            Text('Wilder Taype', style: AppEs.bd.copyWith(color: AppCSS.whi, fontWeight: FontWeight.w700)),
            Text('Creador de ${wii.app}', style: AppEs.sm.copyWith(color: AppCSS.whi.withOpacity(0.8))),
            AppCSS.gs,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppCSS.whi.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppCSS.rS),
              ),
              child: Text(wii.autor, style: AppEs.bdS.copyWith(color: AppCSS.whi)),
            ),
          ]),
        ),
        AppCSS.gm,

        // 📱 Versión _______
        Text('${wii.app} ${wii.version} © ${wii.lanzamiento}',
          style: AppEs.sm.copyWith(color: AppCSS.grs)),
        AppCSS.gm,
      ]),
    ),
  );

  Widget _p(String tx) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(tx, style: AppEs.bdS.copyWith(height: 1.6), textAlign: TextAlign.justify),
  );
}
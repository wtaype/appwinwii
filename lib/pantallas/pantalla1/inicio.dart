import 'package:flutter/material.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../../wii.dart';

// 🏠 PANTALLA INICIO _______
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext ctx) => SafeArea(
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _hero(),
        AppCSS.gl,
        _statsGrid(),
        AppCSS.gl,
        _secTit('Todo lo que', 'necesitas'),
        AppCSS.gs,
        Text('6 módulos para controlar tu semana', style: AppEs.lbl),
        AppCSS.gm,
        _featGrid(),
        AppCSS.gl,
        _secTit('¿Por qué', '${wii.app}?'),
        AppCSS.gm,
        _beneList(),
        AppCSS.gl,
        _cta(),
        AppCSS.gm,
      ]),
    ),
  );

  // 👋 Hero _______
  static Widget _hero() => Container(
    padding: const EdgeInsets.all(AppCSS.l),
    decoration: AppCSS.glass,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(Wi.hi(), style: AppEs.bd),
        const SizedBox(width: 4),
        const Text('👋', style: TextStyle(fontSize: 22)),
      ]),
      AppCSS.gs,
      Wi.gTxt('Organiza tu semana', sz: 22),
      Text('como un profesional', style: AppEs.h3.copyWith(color: AppCSS.mco)),
      AppCSS.gm,
      Text(
        'Gestiona tu horario, tareas y notas diarias con un planificador inteligente. 100% gratis.',
        style: AppEs.bdS.copyWith(height: 1.5),
      ),
      AppCSS.gm,
      Row(children: [
        Text(Wi.dia(), style: AppEs.lbl.copyWith(color: AppCSS.mco)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppCSS.mco.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppCSS.rS),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.circle, size: 8, color: AppCSS.ok),
            const SizedBox(width: 4),
            Text('Hoy', style: AppEs.sm.copyWith(color: AppCSS.mco)),
          ]),
        ),
      ]),
    ]),
  );

  // 📊 Stats _______
  static Widget _statsGrid() => GridView.count(
    crossAxisCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: AppCSS.s, crossAxisSpacing: AppCSS.s,
    childAspectRatio: 0.85,
    children: const [
      Stat(val: '7', lbl: 'Días', ico: Icons.calendar_today, color: AppCSS.cHor),
      Stat(val: '100%', lbl: 'Gratis', ico: Icons.favorite, color: AppCSS.cTar),
      Stat(val: '2026', lbl: 'Actual', ico: Icons.update, color: AppCSS.cPln),
      Stat(val: '24h', lbl: 'Organiza', ico: Icons.schedule, color: AppCSS.cLog),
    ],
  );

  // 🧩 Features _______
  static const _feat = [
    {'ico': Icons.calendar_month, 'nom': 'Horario', 'desc': 'Visualiza tu semana completa', 'clr': AppCSS.cHor},
    {'ico': Icons.checklist, 'nom': 'Planes', 'desc': 'Organiza tus pendientes', 'clr': AppCSS.cPln},
    {'ico': Icons.view_week, 'nom': 'Semanal', 'desc': 'Vista global de 7 días', 'clr': AppCSS.cSem},
    {'ico': Icons.folder_open, 'nom': 'Tareas', 'desc': 'Proyectos por cerrar', 'clr': AppCSS.cTar},
    {'ico': Icons.calendar_view_month, 'nom': 'Mes', 'desc': 'Calendario mensual', 'clr': AppCSS.cMes},
    {'ico': Icons.emoji_events, 'nom': 'Logros', 'desc': 'Celebra tu progreso', 'clr': AppCSS.cLog},
  ];

  static Widget _featGrid() => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: AppCSS.s, crossAxisSpacing: AppCSS.s,
    childAspectRatio: 1.4,
    children: _feat.map((f) => Container(
      padding: const EdgeInsets.all(12),
      decoration: AppCSS.gCard,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (f['clr'] as Color).withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppCSS.rS),
          ),
          child: Icon(f['ico'] as IconData, size: 20, color: f['clr'] as Color),
        ),
        const SizedBox(height: 8),
        Text(f['nom'] as String, style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(f['desc'] as String, style: AppEs.sm, maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
    )).toList(),
  );

  // 💡 Beneficios _______
  static const _bene = [
    {'ico': Icons.psychology, 'tit': 'Pensado para ti', 'desc': 'Diseñado como el horario de un profesional real.'},
    {'ico': Icons.layers, 'tit': 'Todo organizado', 'desc': 'Horario, notas, to-do list y logros en un lugar.'},
    {'ico': Icons.rocket_launch, 'tit': 'Rápido y elegante', 'desc': 'Interfaz limpia que responde al instante.'},
  ];

  static Widget _beneList() => Column(
    children: _bene.map((b) => Padding(
      padding: const EdgeInsets.only(bottom: AppCSS.s),
      child: Glass(child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppCSS.gSky,
            borderRadius: BorderRadius.circular(AppCSS.rM),
          ),
          child: Icon(b['ico'] as IconData, color: AppCSS.F, size: 22),
        ),
        AppCSS.ghm,
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(b['tit'] as String, style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(b['desc'] as String, style: AppEs.sm, maxLines: 2, overflow: TextOverflow.ellipsis),
        ])),
      ])),
    )).toList(),
  );

  // 🚀 CTA _______
  static Widget _cta() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppCSS.l),
    decoration: BoxDecoration(
      gradient: AppCSS.gSky,
      borderRadius: BorderRadius.circular(AppCSS.rXL),
    ),
    child: Column(children: [
      const Icon(Icons.calendar_month, size: 40, color: AppCSS.F),
      AppCSS.gs,
      Text('¿Listo para organizar\ntu semana?', textAlign: TextAlign.center,
        style: AppEs.h3.copyWith(color: AppCSS.F)),
      AppCSS.gs,
      Text('Empieza ahora, es completamente gratis', textAlign: TextAlign.center,
        style: AppEs.sm.copyWith(color: AppCSS.F.withOpacity(0.8))),
      AppCSS.gm,
      Wrap(spacing: 6, runSpacing: 6, alignment: WrapAlignment.center,
        children: _feat.map((f) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppCSS.F.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppCSS.rS),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(f['ico'] as IconData, size: 14, color: AppCSS.F),
            const SizedBox(width: 4),
            Text(f['nom'] as String, style: AppEs.sm.copyWith(color: AppCSS.F)),
          ]),
        )).toList(),
      ),
      AppCSS.gm,
      Text('${wii.autor} · ${wii.app} ${wii.version} © ${wii.lanzamiento}',
        style: AppEs.sm.copyWith(color: AppCSS.F.withOpacity(0.6))),
    ]),
  );

  // 📌 Título sección _______
  static Widget _secTit(String t1, String t2) => Row(children: [
    Text('$t1 ', style: AppEs.h3),
    Wi.gTxt(t2, sz: 18),
  ]);
}
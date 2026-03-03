import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wicss.dart';

// 🎯 WIDGETS Y HELPERS REUTILIZABLES v10 _______
// 👋 Saludo v10 _______
String Saludar() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Buenos días ☀️';
  if (h < 18) return 'Buenas tardes 🌤️';
  return 'Buenas noches 🌙';
}

// 📅 Fecha v10 — centraliza _fmtFecha x5 archivos _______
String wiFecha(String f, {bool anio = false}) {
  try {
    final d = DateTime.parse(f);
    const m = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    return anio ? '${d.day} ${m[d.month - 1]} ${d.year}' : '${d.day} ${m[d.month - 1]}';
  } catch (_) { return f; }
}

// 📆 Dia v10 — "Lunes, 2 Mar" _______
String wiDia() {
  const dias = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];
  const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
  final n = DateTime.now();
  return '${dias[n.weekday % 7]}, ${n.day} ${meses[n.month - 1]}';
}

// ⏳ Dias restantes v10 — centraliza _diasRest x2 archivos _______
Widget diasRestantes(String f) {
  try {
    final hoy = DateTime.now();
    final hoyStr = '${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
    final diff = DateTime.parse(f).difference(DateTime.parse(hoyStr)).inDays;
    if (diff < 0) return Text('${-diff}d atrás', style: AppEs.sm.copyWith(color: AppCSS.err, fontWeight: FontWeight.w600));
    if (diff == 0) return Text('Hoy', style: AppEs.sm.copyWith(color: AppCSS.mco, fontWeight: FontWeight.w600));
    return Text('${diff}d', style: AppEs.sm.copyWith(color: AppCSS.ok, fontWeight: FontWeight.w600));
  } catch (_) { return const SizedBox.shrink(); }
}

// 🎨 Color hex v10 — centraliza parser x5 archivos _______
Color wicoHx(String? hex, Color fallback) {
  if (hex == null || hex.isEmpty) return fallback;
  try { return Color(int.parse('0xFF${hex.replaceAll('#', '')}')); }
  catch (_) { return fallback; }
}

// 🌈 Gradient texto v10 _______
Widget gdTexto(String tx, {double sz = 24}) => ShaderMask(
  shaderCallback: (b) => AppCSS.gSky.createShader(b),
  child: Text(tx, style: GoogleFonts.poppins(fontSize: sz, fontWeight: FontWeight.w700, color: Colors.white)),
);

// 🔔 Notificacion v10 — 4 tipos como widev.js _______
class Notificacion {
  static void ok(BuildContext c, String m) => _show(c, m, AppCSS.ok, Icons.check_circle);
  static void err(BuildContext c, String m) => _show(c, m, AppCSS.err, Icons.error);
  static void wrn(BuildContext c, String m) => _show(c, m, AppCSS.wrn, Icons.warning_amber);
  static void info(BuildContext c, String m) => _show(c, m, AppCSS.inf, Icons.info);

  static void _show(BuildContext c, String m, Color clr, IconData ico) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(ico, color: AppCSS.whi), AppCSS.ghs,
        Expanded(child: Text(m, style: AppEs.bdS.copyWith(color: AppCSS.whi))),
      ]),
      backgroundColor: clr,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rS)),
      duration: AppCSS.trans1,
    ));
  }
}

// 🗑️ Mensaje v10 — centraliza _confirmarEliminar x5 archivos _______
Future<bool?> Mensaje(BuildContext ctx, {String titulo = 'Eliminar', required String msg}) =>
  showDialog<bool>(
    context: ctx,
    builder: (c) => AlertDialog(
      title: Text(titulo, style: AppEs.h3),
      content: Text(msg, style: AppEs.bd),
      backgroundColor: AppCSS.whi,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: Text('Cancelar', style: AppEs.bdS.copyWith(color: AppCSS.grs)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(c, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppCSS.err,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rS)),
          ),
          child: Text('Eliminar', style: AppEs.bdS.copyWith(color: AppCSS.whi)),
        ),
      ],
    ),
  );

// 🏷️ wiBox v10 — centraliza _tag/_badge x4 archivos _______
Widget wiBox(IconData ico, String lbl, Color clr) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  decoration: BoxDecoration(color: clr.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
  child: Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(ico, size: 10, color: clr),
    const SizedBox(width: 3),
    Text(lbl, style: AppEs.sm.copyWith(color: clr)),
  ]),
);

// 🔘 wiBoxs v10 — centraliza _tagDot x2 archivos _______
Widget wiBoxs(String lbl, Color clr) => Row(mainAxisSize: MainAxisSize.min, children: [
  Container(width: 8, height: 8, decoration: BoxDecoration(color: clr, shape: BoxShape.circle)),
  const SizedBox(width: 3),
  Text(lbl, style: AppEs.sm),
]);

// 🔘 wiFiltro v10 — centraliza _filtroChip x3 archivos _______
Widget wiFiltro({
  required String keyF, required String lbl, required IconData ico,
  required Color clr, required String sel, required VoidCallback onTap, int? count,
}) {
  final activo = sel == keyF;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: activo ? clr.withOpacity(0.15) : AppCSS.whi.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppCSS.rS),
        border: Border.all(color: activo ? clr : AppCSS.brd.withOpacity(0.5)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(ico, size: 14, color: activo ? clr : AppCSS.grs),
        const SizedBox(width: 4),
        Text(lbl, style: AppEs.sm.copyWith(
          color: activo ? clr : AppCSS.tx2,
          fontWeight: activo ? FontWeight.w600 : FontWeight.w500,
        )),
        if (count != null && count > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: activo ? clr : AppCSS.grs.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count', style: AppEs.sm.copyWith(
              color: activo ? AppCSS.whi : AppCSS.tx3, fontSize: 10,
            )),
          ),
        ],
      ]),
    ),
  );
}

// 📊 wiStat v10 — centraliza _statChip x3 archivos _______
Widget wiStat(String val, String lbl, IconData ico, Color clr, {bool vertical = true}) => Expanded(
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: AppCSS.gls2,
    child: vertical
      ? Column(children: [
          Icon(ico, size: 18, color: clr),
          const SizedBox(height: 2),
          Text(val, style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
          Text(lbl, style: AppEs.sm),
        ])
      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(ico, size: 16, color: clr),
          const SizedBox(width: 6),
          Text(val, style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          Text(lbl, style: AppEs.sm),
        ]),
  ),
);

// 📈 wiProgress v10 — centraliza LinearProgressIndicator x4 archivos _______
Widget wiProgress(double value, Color clr, {double h = 6}) => ClipRRect(
  borderRadius: BorderRadius.circular(h / 2),
  child: LinearProgressIndicator(
    value: value.clamp(0.0, 1.0), minHeight: h,
    backgroundColor: AppCSS.brd.withOpacity(0.3),
    valueColor: AlwaysStoppedAnimation<Color>(clr),
  ),
);

// 💳 Glass v10 — tarjeta glass _______
class Glass extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? pad;
  const Glass({super.key, required this.child, this.onTap, this.pad});

  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: pad ?? const EdgeInsets.all(AppCSS.m),
      decoration: AppCSS.gls2,
      child: child,
    ),
  );
}

// 📊 Stat v10 — card de estadística _______
class Stat extends StatelessWidget {
  final String val;
  final String lbl;
  final IconData ico;
  final Color color;
  const Stat({super.key, required this.val, required this.lbl, required this.ico, this.color = AppCSS.mco});

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(AppCSS.m),
    decoration: AppCSS.gls2,
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(ico, color: color, size: 28),
      const SizedBox(height: 6),
      Text(val, style: AppEs.h3.copyWith(color: color)),
      Text(lbl, style: AppEs.sm),
    ]),
  );
}

// 😢 Vacio v10 — sin datos _______
class Vacio extends StatelessWidget {
  final String msg;
  final IconData ico;
  final String? txtBtn;
  final VoidCallback? onTap;
  const Vacio({super.key, required this.msg, this.ico = Icons.inbox, this.txtBtn, this.onTap});

  @override
  Widget build(BuildContext ctx) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(ico, size: 80, color: AppCSS.brd),
      AppCSS.gm,
      Text(msg, style: AppEs.h3, textAlign: TextAlign.center),
      if (txtBtn != null && onTap != null) ...[
        AppCSS.gl,
        Btn(txt: txtBtn!, onTap: onTap!, ico: Icons.refresh),
      ],
    ]),
  );
}

// 🔄 Load v10 — cargando _______
class Load extends StatelessWidget {
  final String? msg;
  const Load({super.key, this.msg});

  @override
  Widget build(BuildContext ctx) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircularProgressIndicator(color: AppCSS.mco),
      if (msg != null) ...[AppCSS.gm, Text(msg!, style: AppEs.bd)],
    ]),
  );
}

// 🎯 Btn v10 — botón principal _______
class Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onTap;
  final IconData? ico;
  final bool load;
  final Color? color;
  const Btn({super.key, required this.txt, required this.onTap, this.ico, this.load = false, this.color});

  @override
  Widget build(BuildContext ctx) => ElevatedButton.icon(
    onPressed: load ? null : onTap,
    icon: load
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Icon(ico ?? Icons.check),
    label: Text(txt),
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? AppCSS.mco,
      padding: const EdgeInsets.symmetric(horizontal: AppCSS.l, vertical: AppCSS.m),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
    ),
  );
}

// 📝 Campo v10 — input de texto _______
class Campo extends StatelessWidget {
  final String lbl;
  final String? hint;
  final IconData? ico;
  final bool pass;
  final TextEditingController? ctrl;
  final String? Function(String?)? vld;
  final TextInputType kb;
  const Campo({super.key, required this.lbl, this.hint, this.ico, this.pass = false, this.ctrl, this.vld, this.kb = TextInputType.text});

  @override
  Widget build(BuildContext ctx) => TextFormField(
    controller: ctrl, obscureText: pass, validator: vld, keyboardType: kb,
    style: AppEs.bd,
    decoration: InputDecoration(
      labelText: lbl, hintText: hint,
      prefixIcon: ico != null ? Icon(ico, color: AppCSS.mco) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppCSS.rM), borderSide: const BorderSide(color: AppCSS.brd)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppCSS.rM), borderSide: const BorderSide(color: AppCSS.mco, width: 2)),
      filled: true, fillColor: AppCSS.inp,
    ),
  );
}
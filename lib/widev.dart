import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wicss.dart';

// 🎯 WIDGETS REUTILIZABLES - Tema Cielo _______

// 🎯 Botón principal
class Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onTap;
  final IconData? ico;
  final bool load;
  final Color? color;

  const Btn({
    super.key, required this.txt, required this.onTap,
    this.ico, this.load = false, this.color,
  });

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

// 📝 Campo de texto
class Campo extends StatelessWidget {
  final String lbl;
  final String? hint;
  final IconData? ico;
  final bool pass;
  final TextEditingController? ctrl;
  final String? Function(String?)? vld;
  final TextInputType kb;

  const Campo({
    super.key, required this.lbl, this.hint, this.ico,
    this.pass = false, this.ctrl, this.vld,
    this.kb = TextInputType.text,
  });

  @override
  Widget build(BuildContext ctx) => TextFormField(
    controller: ctrl, obscureText: pass,
    validator: vld, keyboardType: kb,
    style: AppEs.bd,
    decoration: InputDecoration(
      labelText: lbl, hintText: hint,
      prefixIcon: ico != null ? Icon(ico, color: AppCSS.mco) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCSS.rM),
        borderSide: const BorderSide(color: AppCSS.brd),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCSS.rM),
        borderSide: const BorderSide(color: AppCSS.mco, width: 2),
      ),
      filled: true, fillColor: AppCSS.inp,
    ),
  );
}

// 💳 Tarjeta glass
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
      decoration: AppCSS.gCard,
      child: child,
    ),
  );
}

// 🏷️ Chip módulo
class Chip2 extends StatelessWidget {
  final String txt;
  final IconData ico;
  final Color color;
  final VoidCallback? onTap;

  const Chip2({
    super.key, required this.txt, required this.ico,
    required this.color, this.onTap,
  });

  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppCSS.rS),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(ico, size: 16, color: color), AppCSS.ghs,
        Text(txt, style: AppEs.bdS.copyWith(color: color, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

// 📊 Stat card
class Stat extends StatelessWidget {
  final String val;
  final String lbl;
  final IconData ico;
  final Color color;

  const Stat({
    super.key, required this.val, required this.lbl,
    required this.ico, this.color = AppCSS.mco,
  });

  @override
  Widget build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(AppCSS.m),
    decoration: AppCSS.gCard,
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(ico, color: color, size: 28),
      const SizedBox(height: 6),
      Text(val, style: AppEs.h2.copyWith(color: color)),
      Text(lbl, style: AppEs.sm),
    ]),
  );
}

// 😢 Sin datos
class Vacio extends StatelessWidget {
  final String msg;
  final IconData ico;
  final String? txtBtn;
  final VoidCallback? onTap;

  const Vacio({
    super.key, required this.msg,
    this.ico = Icons.inbox, this.txtBtn, this.onTap,
  });

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

// 🍕 Snackbar
class Msg {
  static void ok(BuildContext c, String m) => _s(c, m, false);
  static void er(BuildContext c, String m) => _s(c, m, true);

  static void _s(BuildContext c, String m, bool e) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(e ? Icons.error : Icons.check_circle, color: Colors.white),
        AppCSS.ghs,
        Expanded(child: Text(m, style: AppEs.bdS.copyWith(color: Colors.white))),
      ]),
      backgroundColor: e ? AppCSS.err : AppCSS.ok,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rS)),
      duration: AppCSS.trL,
    ));
  }
}

// 🔄 Cargando
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

// 🎨 Helpers
class Wi {
  static Widget caja(String tx) => Container(
    padding: AppCSS.pM, decoration: AppCSS.gCard,
    child: Text(tx, style: AppEs.bd.copyWith(height: 1.5), textAlign: TextAlign.center),
  );

  static Widget img(String r) => ClipRRect(
    borderRadius: BorderRadius.circular(AppCSS.rM),
    child: Image.asset(r, fit: BoxFit.cover),
  );

  static Widget gTxt(String tx, {double sz = 24}) => ShaderMask(
    shaderCallback: (b) => AppCSS.gSky.createShader(b),
    child: Text(tx, style: GoogleFonts.poppins(
      fontSize: sz, fontWeight: FontWeight.w700, color: Colors.white,
    )),
  );

  static Widget line() => Container(
    width: 60, height: 3,
    decoration: BoxDecoration(gradient: AppCSS.gSky, borderRadius: BorderRadius.circular(2)),
  );

  static String hi() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días ☀️';
    if (h < 18) return 'Buenas tardes 🌤️';
    return 'Buenas noches 🌙';
  }

  static String dia() {
    const dias = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];
    const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    final n = DateTime.now();
    return '${dias[n.weekday % 7]}, ${n.day} ${meses[n.month - 1]}';
  }
}
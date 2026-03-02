import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎨 COLORES Y DISEÑO - TEMA CIELO _______
class AppCSS {
  static const String desc = 'Organiza tu semana como un profesional';
  static const String by = 'Con mucho amor ❤️';

  // 🖼️ ASSETS _______
  static const String lgPath = 'assets/images/logo.png';
  static const String lgSmile = 'assets/images/smile.png';

  static Widget get logo => Image.asset(
    lgPath, width: 80, height: 80, fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.calendar_month, size: 80, color: mco),
  );

  static Widget get logoC => Container(
    width: 80, height: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle, color: F,
      boxShadow: [BoxShadow(color: mco.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
    ),
    child: ClipOval(child: logo),
  );

  // 🎨 CIELO - PRINCIPALES _______
  static const Color mco = Color(0xFF1978D7); // --mco
  static const Color hv  = Color(0xFF00A8E6); // --hv
  static const Color hva = Color(0xFF1873CD); // --hva
  static const Color sky = Color(0xFF0EBEFF); // --Cielo
  static const Color bg  = Color(0xFFCCEFFF); // --bg
  static const Color wb  = Color(0xFFE5F7FF); // --wb
  static const Color inp = Color(0xFFF0F9FF); // --inp
  static const Color brd = Color(0xFFB8D9EB); // --brd

  // 📝 TEXTOS _______
  static const Color tx  = Color(0xFF000000); // --tx
  static const Color tx1 = Color(0xFF1A1A1A); // --tx1
  static const Color tx2 = Color(0xFF333333); // --tx2
  static const Color tx3 = Color(0xFF666666); // --tx3
  static const Color txa = Color(0xFFFFFFFF); // --txa
  static const Color F   = Colors.white;

  // ✅ ESTADOS _______
  static const Color ok  = Color(0xFF3CD741); // --success
  static const Color err = Color(0xFFFF3849); // --error
  static const Color wrn = Color(0xFFFFA726); // --warning
  static const Color inf = Color(0xFF00A8E6); // --info

  // ⚫ GRISES _______
  static const Color G   = Color(0xFF374151); // --G
  static const Color D   = Color(0xFFDDDDDD); // --D
  static const Color grs = Color(0xFF9E9E9E);
  static const Color grL = Color(0xFFF5F5F5);

  // 🧩 MÓDULOS _______
  static const Color cHor = Color(0xFF0EBEFF); // Horario
  static const Color cPln = Color(0xFF29C72E); // Planes
  static const Color cSem = Color(0xFF7000FF); // Semanal
  static const Color cTar = Color(0xFFFF5C69); // Tareas
  static const Color cMes = Color(0xFFFFB800); // Mes
  static const Color cLog = Color(0xFFFF8C00); // Logros

  // 🔲 EXTRAS _______
  static const Color O    = Colors.transparent;
  static const Color shd  = Color(0x1A000000);

  // 🌈 GRADIENTES _______
  static const LinearGradient gDia = LinearGradient(
    colors: [Color(0xFF0EBEFF), Color(0xFF29C72E)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient gSky = LinearGradient(
    colors: [Color(0xFF0EBEFF), Color(0xFF1978D7)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient gBg = LinearGradient(
    colors: [Color(0xFFCCEFFF), Color(0xFFE5F7FF)],
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
  );

  // 📐 ESPACIADOS _______
  static const double s  = 8.0;
  static const double m  = 16.0;
  static const double l  = 24.0;
  static const double xl = 32.0;

  // 📐 RADIOS _______
  static const double rS  = 8.0;
  static const double rM  = 12.0;
  static const double rL  = 16.0;
  static const double rXL = 20.0;

  // ⏱️ DURACIONES _______
  static const Duration trF = Duration(milliseconds: 150);
  static const Duration trM = Duration(milliseconds: 300);
  static const Duration trS = Duration(milliseconds: 500);
  static const Duration trL = Duration(milliseconds: 600);
  static const Duration tLd = Duration(seconds: 3);

  // 📱 PADDINGS _______
  static const EdgeInsets pS  = EdgeInsets.all(s);
  static const EdgeInsets pM  = EdgeInsets.symmetric(vertical: 9, horizontal: 10);
  static const EdgeInsets pL  = EdgeInsets.symmetric(vertical: 15, horizontal: 20);
  static const EdgeInsets pXL = EdgeInsets.all(xl);
  static const EdgeInsets pH  = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets pV  = EdgeInsets.symmetric(vertical: m);

  // 📏 GAPS _______
  static Widget get gs  => const SizedBox(height: s);
  static Widget get gm  => const SizedBox(height: m);
  static Widget get gl  => const SizedBox(height: l);
  static Widget get gxl => const SizedBox(height: xl);
  static Widget get ghs => const SizedBox(width: s);
  static Widget get ghm => const SizedBox(width: m);

  // 🪟 GLASS _______
  static BoxDecoration get glass => BoxDecoration(
    gradient: LinearGradient(
      colors: [wb.withOpacity(0.6), F.withOpacity(0.3)],
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(rXL),
    border: Border.all(color: F.withOpacity(0.4), width: 1.5),
    boxShadow: [BoxShadow(color: mco.withOpacity(0.1), blurRadius: 20, spreadRadius: 5, offset: const Offset(0, 10))],
  );

  static BoxDecoration get gCard => BoxDecoration(
    color: F.withOpacity(0.7),
    borderRadius: BorderRadius.circular(rL),
    border: Border.all(color: brd.withOpacity(0.5)),
    boxShadow: [BoxShadow(color: mco.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
  );

  static BoxDecoration get gInp => BoxDecoration(
    color: inp, borderRadius: BorderRadius.circular(rM),
    border: Border.all(color: brd),
  );

  // 🌫️ SOMBRAS _______
  static List<BoxShadow> get shdS => [
    BoxShadow(color: mco.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
  ];
  static List<BoxShadow> get shdM => [
    BoxShadow(color: shd, blurRadius: 10, offset: const Offset(0, 4)),
  ];
}

// 🎭 ESTILOS DE TEXTO _______
class AppEs {
  // 🎨 TEMA APP _______
  static ThemeData get tema => ThemeData(
    scaffoldBackgroundColor: AppCSS.bg,
    primarySwatch: Colors.blue,
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppCSS.mco,
      foregroundColor: AppCSS.F,
      elevation: 0, toolbarHeight: 45,
      titleTextStyle: btn, centerTitle: true,
      iconTheme: const IconThemeData(color: AppCSS.F, size: 22),
    ),
    textTheme: TextTheme(
      headlineLarge: h1, headlineMedium: h2,
      titleLarge: h3, bodyLarge: bd, bodyMedium: bdS,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppCSS.mco, foregroundColor: AppCSS.F,
        textStyle: btn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppCSS.mco,
      unselectedItemColor: AppCSS.grs,
      elevation: 10, type: BottomNavigationBarType.fixed,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // 📝 TEXTOS _______
  static TextStyle get h1  => _p(32, FontWeight.w700, AppCSS.mco);
  static TextStyle get h2  => _p(24, FontWeight.w600, AppCSS.mco);
  static TextStyle get h3  => _p(18, FontWeight.w600, AppCSS.tx1);
  static TextStyle get bd  => _p(16, FontWeight.w500, AppCSS.tx1);
  static TextStyle get bdS => _p(14, FontWeight.w500, AppCSS.tx2);
  static TextStyle get lbl => _p(13, FontWeight.w500, AppCSS.tx3);
  static TextStyle get sm  => _p(11, FontWeight.w500, AppCSS.tx3);
  static TextStyle get btn => _p(16, FontWeight.w600, AppCSS.F);

  // ✨ ESPECIALES _______
  static TextStyle get gTit => _p(24, FontWeight.w700, AppCSS.sky);
  static TextStyle get gSub => _p(15, FontWeight.w500, AppCSS.tx2);
  static TextStyle get iSM  => _p(13, FontWeight.w500, AppCSS.tx1);
  static TextStyle get tSM  => _p(11, FontWeight.w500, AppCSS.tx2);

  // 🔧 HELPER _______
  static TextStyle _p(double sz, FontWeight w, Color c) =>
      GoogleFonts.poppins(fontSize: sz, fontWeight: w, color: c);
}

// ❌ VALIDACIÓN ERROR _______
class VdE {
  static const Color brd = Color(0xFFFF3849);
  static const Color tx  = Color(0xFFD32F2F);
  static const Color bg  = Color(0xFFFFEBEE);
  static const Color ico = Color(0xFFFF3849);
}

// ✅ VALIDACIÓN OK _______
class VdO {
  static const Color brd = Color(0xFF3CD741);
  static const Color tx  = Color(0xFF2E7D32);
  static const Color bg  = Color(0xFFE8F5E8);
  static const Color ico = Color(0xFF3CD741);
}
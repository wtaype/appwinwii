import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎨 COLORES Y DISEÑO - TEMA CIELO v10 _______
class AppCSS {
  static const String desc = 'Organiza tu semana como un profesional';
  static const String by = 'Con mucho amor ❤️';

  // 🖼️ ASSETS _______
  static const String lgPath = 'assets/images/logo.png';
  static Widget get logo => Image.asset(
    lgPath, width: 80, height: 80, fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.calendar_month, size: 80, color: mco),
  );

  // 🎨 PRINCIPALES _______
  static const Color mco = Color(0xFF1978D7); // main color
  static const Color bg  = Color(0xFFCCEFFF); // fondo
  static const Color wb  = Color(0xFFE5F7FF); // fondo suave
  static const Color whi = Colors.white;       // blanco
  static const Color blk = Color(0xFF000000);  // negro
  static const Color grs = Color(0xFF9E9E9E);  // gris
  static const Color brd = Color(0xFFB8D9EB);  // borde
  static const Color inp = Color(0xFFF0F9FF);  // input
  static const Color O   = Colors.transparent;  // transparente

  // 📝 TEXTOS _______
  static const Color tx  = Color(0xFF000000); // tx principal
  static const Color tx1 = Color(0xFF1A1A1A); // tx primero
  static const Color tx2 = Color(0xFF333333); // tx segundo
  static const Color tx3 = Color(0xFF666666); // tx tercero

  // ✅ ESTADOS _______
  static const Color ok  = Color(0xFF3CD741); // success
  static const Color err = Color(0xFFFF3849); // error
  static const Color wrn = Color(0xFFFFA726); // warning
  static const Color inf = Color(0xFF00A8E6); // info

  // 🧩 MÓDULOS bg1-bg6 _______
  static const Color bg1 = Color(0xFF0EBEFF); // Horario
  static const Color bg2 = Color(0xFF29C72E); // Planes
  static const Color bg3 = Color(0xFF7000FF); // Semanal
  static const Color bg4 = Color(0xFFFF5C69); // Tareas
  static const Color bg5 = Color(0xFFFFB800); // Mes
  static const Color bg6 = Color(0xFFFF8C00); // Logros

  // 🌈 GRADIENTES _______
  static const LinearGradient gDia = LinearGradient(
    colors: [Color(0xFF0EBEFF), Color(0xFF29C72E)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient gSky = LinearGradient(
    colors: [Color(0xFF0EBEFF), Color(0xFF1978D7)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // 📐 ESPACIADOS _______
  static const double s  = 8.0;
  static const double m  = 16.0;
  static const double l  = 24.0;

  // 📐 RADIOS _______
  static const double rS  = 8.0;
  static const double rM  = 12.0;
  static const double rL  = 16.0;
  static const double rXL = 20.0;

  // ⏱️ TRANSICIONES trans1-trans2 _______
  static const Duration trans1 = Duration(milliseconds: 600); // snackbar/msg
  static const Duration trans2 = Duration(seconds: 3);         // loading

  // 📱 PADDINGS _______
  static const EdgeInsets pM = EdgeInsets.symmetric(vertical: 9, horizontal: 10);
  static const EdgeInsets pL = EdgeInsets.symmetric(vertical: 15, horizontal: 20);

  // 📏 GAPS _______
  static Widget get gs  => const SizedBox(height: s);
  static Widget get gm  => const SizedBox(height: m);
  static Widget get gl  => const SizedBox(height: l);
  static Widget get ghs => const SizedBox(width: s);
  static Widget get ghm => const SizedBox(width: m);

  // 🪟 GLASS gls1-gls3 _______
  static BoxDecoration get gls1 => BoxDecoration(
    gradient: LinearGradient(
      colors: [wb.withOpacity(0.6), whi.withOpacity(0.3)],
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(rXL),
    border: Border.all(color: whi.withOpacity(0.4), width: 1.5),
    boxShadow: [BoxShadow(color: mco.withOpacity(0.1), blurRadius: 20, spreadRadius: 5, offset: const Offset(0, 10))],
  );
  static BoxDecoration get gls2 => BoxDecoration(
    color: whi.withOpacity(0.7),
    borderRadius: BorderRadius.circular(rL),
    border: Border.all(color: brd.withOpacity(0.5)),
    boxShadow: [BoxShadow(color: mco.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
  );
  static BoxDecoration get gls3 => BoxDecoration(
    color: whi.withOpacity(0.15),
    borderRadius: BorderRadius.circular(rXL),
    border: Border.all(color: whi.withOpacity(0.25), width: 1.5),
    boxShadow: [BoxShadow(color: blk.withOpacity(0.08), blurRadius: 24, spreadRadius: 2, offset: const Offset(0, 8))],
  );

  // 🌫️ SOMBRAS bx1 _______
  static List<BoxShadow> get bx1 => [
    BoxShadow(color: mco.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
  ];

  // 🔲 BORDES bd1 _______
  static BoxDecoration get bd1 => BoxDecoration(
    color: inp, borderRadius: BorderRadius.circular(rM),
    border: Border.all(color: brd),
  );
}

// 🎭 ESTILOS DE TEXTO v10 _______
class AppEs {
  // 🎨 TEMA APP _______
  static ThemeData get tema => ThemeData(
    scaffoldBackgroundColor: AppCSS.bg,
    primarySwatch: Colors.blue,
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppCSS.mco, foregroundColor: AppCSS.whi,
      elevation: 0, toolbarHeight: 45,
      titleTextStyle: btn, centerTitle: true,
      iconTheme: const IconThemeData(color: AppCSS.whi, size: 22),
    ),
    textTheme: TextTheme(titleLarge: h3, bodyLarge: bd, bodyMedium: bdS),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppCSS.mco, foregroundColor: AppCSS.whi,
        textStyle: btn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white, selectedItemColor: AppCSS.mco,
      unselectedItemColor: AppCSS.grs, elevation: 10,
      type: BottomNavigationBarType.fixed,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // 📝 TEXTOS _______
  static TextStyle get h3  => _p(18, FontWeight.w600, AppCSS.tx1);
  static TextStyle get bd  => _p(16, FontWeight.w500, AppCSS.tx1);
  static TextStyle get bdS => _p(14, FontWeight.w500, AppCSS.tx2);
  static TextStyle get lbl => _p(13, FontWeight.w500, AppCSS.tx3);
  static TextStyle get sm  => _p(11, FontWeight.w500, AppCSS.tx3);
  static TextStyle get btn => _p(16, FontWeight.w600, AppCSS.whi);

  // 🔧 HELPER _______
  static TextStyle _p(double sz, FontWeight w, Color c) =>
      GoogleFonts.poppins(fontSize: sz, fontWeight: w, color: c);
}
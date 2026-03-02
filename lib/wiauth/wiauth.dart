import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

// ═══════════════════════════════════════════════════════════════════
// 🎨 COLORES AUTH - Tema Cielo (sincronizado con wicss.dart)
// ═══════════════════════════════════════════════════════════════════
class AuthColores {
  static const Color verdePrimario = Color(0xFF1978D7);   // mco
  static const Color verdeSecundario = Color(0xFF00A8E6);  // hv
  static const Color verdeClaro = Color(0xFFCCEFFF);       // bg
  static const Color verdeSuave = Color(0xFFE5F7FF);       // wb
  static const Color textoOscuro = Color(0xFF1A1A1A);      // tx1
  static const Color textoVerde = Color(0xFF1978D7);       // mco
  static const Color blanco = Colors.white;
  static const Color enlace = Color(0xFF1978D7);           // mco
  static const Color error = Color(0xFFFF3849);            // err
  static const Color errorTexto = Color(0xFFFF3849);       // err
  static const Color errorFondo = Color(0xFFFFEBEE);
  static const Color gris = Color(0xFF9E9E9E);             // grs
}

// ...existing code...
// (Todo lo demás queda igual: AuthEstilos, AuthConstantes, AuthValidadores,
//  AuthFormatos, AuthFirebase, AuthBoton, AuthCampoTexto, etc.)

// ═══════════════════════════════════════════════════════════════════
// 🎭 ESTILOS AUTH - Independiente de recursos/colores.dart
// ═══════════════════════════════════════════════════════════════════
class AuthEstilos {
  static TextStyle get tituloGrande => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AuthColores.textoVerde,
  );

  static TextStyle get subtitulo => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AuthColores.textoOscuro,
  );

  static TextStyle get textoNormal => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AuthColores.textoOscuro,
  );

  static TextStyle get textoChico => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AuthColores.textoOscuro,
  );

  static TextStyle get textoBoton => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AuthColores.blanco,
  );

  static TextStyle get enlace => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AuthColores.enlace,
  );
}

// ═══════════════════════════════════════════════════════════════════
// 📏 CONSTANTES AUTH - Independiente de recursos/constantes.dart
// ═══════════════════════════════════════════════════════════════════
class AuthConstantes {
  static const double espacioChico = 8.0;
  static const double espacioMedio = 16.0;
  static const double espacioGrande = 24.0;
  static const double espacioGigante = 32.0;
  static const double radioChico = 8.0;
  static const double radioMedio = 12.0;
  static const double radioGrande = 16.0;

  static const Duration animacionRapida = Duration(milliseconds: 300);
  static const Duration animacionLenta = Duration(milliseconds: 600);

  static Widget get espacioChicoWidget => SizedBox(height: espacioChico);
  static Widget get espacioMedioWidget => SizedBox(height: espacioMedio);
  static Widget get espacioGrandeWidget => SizedBox(height: espacioGrande);

  // Logo paths
  static const String logoPath = 'assets/images/logo.png';
  static Widget get logo => Image.asset(
    logoPath,
    width: 80,
    height: 80,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) =>
        Icon(Icons.account_circle, size: 80, color: AuthColores.verdePrimario),
  );

  static Widget get logoCircular => Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: AuthColores.verdePrimario.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ClipOval(child: logo),
  );
}

// ═══════════════════════════════════════════════════════════════════
// ✅ VALIDADORES AUTH - Independiente de recursos/constantes.dart
// ═══════════════════════════════════════════════════════════════════
class AuthValidadores {
  static String? email(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Email requerido';
    if (!EmailValidator.validate(value!)) return 'Email inválido';
    return null;
  }

  static String? usuario(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Usuario requerido';
    if (value!.length < 3) return 'Mínimo 3 caracteres';
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
      return 'Solo letras, números y _';
    }
    return null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) return 'Contraseña requerida';
    if (value!.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? passwordLogin(String? value) {
    if (value?.isEmpty ?? true) return 'Contraseña requerida';
    return null;
  }

  static String? emailOUsuario(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Email o usuario requerido';
    if (value!.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }
}

// ═══════════════════════════════════════════════════════════════════
// 🧹 FORMATEADORES AUTH - Independiente de recursos/constantes.dart
// ═══════════════════════════════════════════════════════════════════
class AuthFormatos {
  static String email(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'\s+'), '');

  static String usuario(String text) => text
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');

  static String emailOUsuario(String text) {
    if (text.contains('@')) return email(text);
    return usuario(text);
  }

  static String texto(String text) => text.trim();
}

// ═══════════════════════════════════════════════════════════════════
// 🔥 FIREBASE AUTH CONFIG - Independiente de recursos/constantes.dart
// ═══════════════════════════════════════════════════════════════════
class AuthFirebase {
  static const String coleccionUsuarios = 'smiles';
  static const int timeoutSegundos = 30;
  static const Duration delayVerificacion = Duration(milliseconds: 300);

  static const Map<String, String> erroresAuth = {
    'email-already-in-use': 'Email ya registrado',
    'weak-password': 'Contraseña muy débil',
    'invalid-email': 'Email inválido',
    'user-not-found': 'Usuario no encontrado',
    'wrong-password': 'Contraseña incorrecta',
    'network-request-failed': 'Sin conexión a internet',
  };

  static String mensajeError(String codigo) =>
      erroresAuth[codigo] ?? 'Email o usuario no existe';

  static const Map<String, String> mensajesExito = {
    'registro': '¡Cuenta creada exitosamente! 🎉',
    'login': '¡Bienvenido de vuelta! 😊',
    'logout': '¡Hasta pronto! 👋',
    'password-reset': 'Email de recuperación enviado 📧',
  };

  static String mensajeExito(String tipo) =>
      mensajesExito[tipo] ?? '¡Operación exitosa!';
}

// ═══════════════════════════════════════════════════════════════════
// 🎨 WIDGETS AUTH - Independiente de recursos/widgets.dart
// ═══════════════════════════════════════════════════════════════════

// 🎯 Botón principal AUTH
class AuthBoton extends StatelessWidget {
  final String texto;
  final VoidCallback alPresionar;
  final IconData? icono;
  final bool estaCargando;
  final Color? colorFondo;

  const AuthBoton({
    super.key,
    required this.texto,
    required this.alPresionar,
    this.icono,
    this.estaCargando = false,
    this.colorFondo,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: estaCargando ? null : alPresionar,
      icon: estaCargando
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icono ?? Icons.check),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorFondo ?? AuthColores.verdePrimario,
        padding: const EdgeInsets.symmetric(
          horizontal: AuthConstantes.espacioGrande,
          vertical: AuthConstantes.espacioMedio,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AuthConstantes.radioMedio),
        ),
      ),
    );
  }
}

// 📝 Campo de texto AUTH
class AuthCampoTexto extends StatelessWidget {
  final String etiqueta;
  final String? pista;
  final IconData? icono;
  final bool esContrasena;
  final TextEditingController? controlador;
  final String? Function(String?)? validador;
  final TextInputType tipoTeclado;

  const AuthCampoTexto({
    super.key,
    required this.etiqueta,
    this.pista,
    this.icono,
    this.esContrasena = false,
    this.controlador,
    this.validador,
    this.tipoTeclado = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: esContrasena,
      validator: validador,
      keyboardType: tipoTeclado,
      style: AuthEstilos.textoNormal,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: pista,
        prefixIcon: icono != null
            ? Icon(icono, color: AuthColores.verdePrimario)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstantes.radioMedio),
          borderSide: BorderSide(color: AuthColores.verdeSecundario),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstantes.radioMedio),
          borderSide: BorderSide(color: AuthColores.verdePrimario, width: 2),
        ),
        filled: true,
        fillColor: AuthColores.blanco,
      ),
    );
  }
}

// 🔄 Indicador de carga AUTH
class AuthIndicadorCarga extends StatelessWidget {
  final String? mensaje;

  const AuthIndicadorCarga({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AuthColores.verdePrimario),
          if (mensaje != null) ...[
            const SizedBox(height: AuthConstantes.espacioMedio),
            Text(mensaje!, style: AuthEstilos.textoNormal),
          ],
        ],
      ),
    );
  }
}

// 🍕 Helper para mensajes AUTH
class AuthMensajes {
  static void mostrarExito(BuildContext contexto, String mensaje) {
    _mostrarMensaje(contexto, mensaje, esError: false);
  }

  static void mostrarError(BuildContext contexto, String mensaje) {
    _mostrarMensaje(contexto, mensaje, esError: true);
  }

  static void _mostrarMensaje(
    BuildContext contexto,
    String mensaje, {
    required bool esError,
  }) {
    ScaffoldMessenger.of(contexto).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              esError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: AuthConstantes.espacioChico),
            Expanded(
              child: Text(
                mensaje,
                style: AuthEstilos.textoNormal.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: esError
            ? Colors.red.shade600
            : AuthColores.verdePrimario,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AuthConstantes.radioChico),
        ),
        duration: AuthConstantes.animacionLenta,
      ),
    );
  }
}

// 🔗 Widget de enlace AUTH
class AuthEnlace extends StatelessWidget {
  final String texto;
  final VoidCallback alPresionar;

  const AuthEnlace({super.key, required this.texto, required this.alPresionar});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: alPresionar,
      child: Text(texto, style: AuthEstilos.enlace),
    );
  }
}
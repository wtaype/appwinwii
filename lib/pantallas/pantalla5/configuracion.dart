import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../wii.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../../wiauth/auth_fb.dart';
import '../../wiauth/login.dart';
import '../../wiauth/usuario.dart';
import '../../wiauth/firestore_fb.dart';
import 'acerca.dart';

class PantallaConfig extends StatefulWidget {
  const PantallaConfig({super.key});

  @override
  State<PantallaConfig> createState() => _PantallaConfigState();
}

class _PantallaConfigState extends State<PantallaConfig> {
  // 🎯 Cache estático 3 niveles
  static Usuario? _uCache;
  static DateTime? _fCache;
  static const _tExp = Duration(hours: 6);
  static const _kU = 'usuario_cache';
  static const _kF = 'fecha_cache';

  final _fotoCtrl = TextEditingController();
  bool _cargando = false, _cargandoU = true;
  Usuario? _u;

  @override
  void initState() {
    super.initState();
    _cargarU();
  }

  Future<void> _cargarU() async {
    setState(() => _cargandoU = true);
    try {
      _u = await _obtenerUConCache();
      if (_u?.foto?.isNotEmpty == true) _fotoCtrl.text = _u!.foto!;
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _cargandoU = false);
    }
  }

  // 🧠 Cache 3 niveles: memoria → storage → firebase
  Future<Usuario?> _obtenerUConCache() async {
    if (!AuthServicio.estaLogueado) return null;
    final email = AuthServicio.usuarioActual!.email!;

    // 1. Memoria
    if (_uCache != null && _cacheOk()) return _uCache;

    // 2. Storage
    final uSto = await _deStorage();
    if (uSto != null && _cacheOk()) return _uCache = uSto;

    // 3. Firebase
    final uFb = await DatabaseServicio.obtenerUsuarioPorEmail(email);
    if (uFb != null) {
      await _aStorage(uFb);
      _uCache = uFb;
      _fCache = DateTime.now();
    }
    return uFb;
  }

  bool _cacheOk() => _fCache != null && DateTime.now().difference(_fCache!) < _tExp;

  Future<void> _aStorage(Usuario u) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kU, jsonEncode(u.toMap()));
      await p.setString(_kF, DateTime.now().toIso8601String());
    } catch (_) {}
  }

  Future<Usuario?> _deStorage() async {
    try {
      final p = await SharedPreferences.getInstance();
      final j = p.getString(_kU), f = p.getString(_kF);
      if (j == null || f == null) return null;
      _fCache = DateTime.parse(f);
      return Usuario.fromMap(jsonDecode(j));
    } catch (_) { return null; }
  }

  Future<void> _limpiarCache() async {
    _uCache = null; _fCache = null;
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_kU); await p.remove(_kF);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext ctx) {
    if (_cargandoU) return const Load(msg: 'Cargando perfil...');
    if (_u == null) return const Vacio(msg: 'Error cargando usuario', ico: Icons.error);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppCSS.pL,
        child: Column(children: [
          // 🔝 Header _______
          _header(),
          AppCSS.gm,
          // 📷 Foto _______
          _foto(),
          AppCSS.gs,
          // 👤 Usuario _______
          Text('@${_u?.usuario ?? 'Usuario'}',
            style: AppEs.h3.copyWith(color: AppCSS.mco)),
          AppCSS.gm,
          // 📋 Info personal _______
          _info(),
          AppCSS.gm,
          // 🖼️ Cambiar foto _______
          _cambiarFoto(),
          AppCSS.gm,
          // 🚪 Cerrar sesión _______
          _btnCerrar(),
          AppCSS.gs,
          // ℹ️ Acerca de _______
          _btnAcerca(),
          AppCSS.gm,
          // 📱 Info app _______
          _infoApp(),
          AppCSS.gm,
        ]),
      ),
    );
  }

  // 🔝 Header _______
  Widget _header() => Glass(child: Row(children: [
    Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppCSS.gSky,
        borderRadius: BorderRadius.circular(AppCSS.rM),
      ),
      child: const Icon(Icons.settings, color: AppCSS.F, size: 22),
    ),
    AppCSS.ghm,
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Configuración', style: AppEs.h3),
      Text('Gestiona tu perfil', style: AppEs.sm),
    ])),
    IconButton(
      icon: const Icon(Icons.refresh, color: AppCSS.mco, size: 20),
      onPressed: _recargarU,
    ),
  ]));

  // 📷 Foto _______
  Widget _foto() => Center(
    child: Container(
      width: 100, height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: AppCSS.F,
        boxShadow: [BoxShadow(color: AppCSS.mco.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipOval(
        child: _u?.foto?.isNotEmpty == true
            ? Image.network(_u!.foto!, width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fotoDefault())
            : _fotoDefault(),
      ),
    ),
  );

  Widget _fotoDefault() => Container(
    width: 100, height: 100,
    decoration: BoxDecoration(shape: BoxShape.circle, color: AppCSS.wb),
    child: ClipOval(
      child: Image.asset(AppCSS.lgSmile, width: 100, height: 100, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.account_circle, size: 60, color: AppCSS.mco)),
    ),
  );

  // 📋 Info _______
  Widget _info() => Glass(child: Column(children: [
    _infoItem('Nombre completo', '${_u?.nombre ?? 'N/A'} ${_u?.apellidos ?? ''}', Icons.badge),
    _div(),
    _infoItem('Email', _u?.email ?? 'N/A', Icons.email),
    _div(),
    _infoItem('Grupo', _u?.grupo ?? 'N/A', Icons.group),
  ]));

  Widget _infoItem(String tit, String val, IconData ico) => Row(children: [
    Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: AppCSS.mco.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(ico, color: AppCSS.mco, size: 20),
    ),
    AppCSS.ghm,
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tit, style: AppEs.sm),
      Text(val, style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
    ])),
  ]);

  Widget _div() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Divider(color: AppCSS.brd.withOpacity(0.5), height: 1),
  );

  // 🖼️ Cambiar foto _______
  Widget _cambiarFoto() => Glass(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppCSS.mco.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.photo_camera, color: AppCSS.mco, size: 20),
      ),
      AppCSS.ghm,
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Foto de Perfil', style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
        Text('Agrega el enlace de tu foto', style: AppEs.sm),
      ])),
    ]),
    AppCSS.gm,
    Campo(lbl: 'URL de la imagen', hint: 'https://ejemplo.com/mi-foto.jpg',
      ico: Icons.link, ctrl: _fotoCtrl, kb: TextInputType.url),
    AppCSS.gm,
    SizedBox(
      width: double.infinity,
      child: Btn(
        txt: _cargando ? 'Actualizando...' : 'Actualizar Foto',
        ico: Icons.update, load: _cargando,
        onTap: _actualizarFoto,
      ),
    ),
  ]));

  // 🚪 Cerrar sesión _______
  Widget _btnCerrar() => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: _cerrarSesion,
      icon: const Icon(Icons.logout),
      label: const Text('Cerrar Sesión'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppCSS.err,
        foregroundColor: AppCSS.F,
        padding: const EdgeInsets.symmetric(vertical: AppCSS.m),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
      ),
    ),
  );

  // ℹ️ Acerca de _______
  Widget _btnAcerca() => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => const PantallaAcerca())),
      icon: const Icon(Icons.info_outline),
      label: const Text('Acerca de'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppCSS.mco,
        side: const BorderSide(color: AppCSS.mco, width: 2),
        padding: const EdgeInsets.symmetric(vertical: AppCSS.m),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
      ),
    ),
  );

  // 📱 Info app _______
  Widget _infoApp() => Column(children: [
    Text('${wii.app} ${wii.version}', style: AppEs.sm),
    AppCSS.gs,
    Text('${AppCSS.by} · ${wii.autor}', style: AppEs.sm.copyWith(fontStyle: FontStyle.italic)),
  ]);

  // 🔄 Recargar _______
  Future<void> _recargarU() async {
    setState(() => _cargandoU = true);
    try {
      if (!AuthServicio.estaLogueado) return;
      _uCache = null; _fCache = null;
      final u = await DatabaseServicio.obtenerUsuarioPorEmail(
        AuthServicio.usuarioActual!.email!);
      if (u != null && mounted) {
        await _aStorage(u);
        _uCache = u; _fCache = DateTime.now();
        setState(() => _u = u);
        Msg.ok(context, 'Datos actualizados 🔄');
      }
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _cargandoU = false);
    }
  }

  // 📷 Actualizar foto _______
  Future<void> _actualizarFoto() async {
    final url = _fotoCtrl.text.trim();
    if (url.isEmpty) return Msg.er(context, 'Ingresa un enlace válido');

    setState(() => _cargando = true);
    try {
      if (_u != null) {
        await DatabaseServicio.actualizarFotoPerfil(_u!.usuario, url);
        final uAct = Usuario(
          email: _u!.email, usuario: _u!.usuario,
          nombre: _u!.nombre, apellidos: _u!.apellidos,
          grupo: _u!.grupo, genero: _u!.genero, rol: _u!.rol,
          activo: _u!.activo, creacion: _u!.creacion, uid: _u!.uid,
          ultimaActividad: _u!.ultimaActividad,
          aceptoTerminos: _u!.aceptoTerminos, foto: url,
        );
        await _aStorage(uAct);
        _uCache = uAct; _fCache = DateTime.now();
        setState(() => _u = uAct);
        _fotoCtrl.clear();
        Msg.ok(context, '¡Foto actualizada! 📷');
      }
    } catch (e) {
      Msg.er(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // 🚪 Cerrar sesión _______
  Future<void> _cerrarSesion() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cerrar Sesión', style: AppEs.h3),
        content: Text('¿Estás seguro que quieres cerrar sesión?', style: AppEs.bd),
        backgroundColor: AppCSS.F,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: AppEs.bdS.copyWith(color: AppCSS.grs)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppCSS.err,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rS)),
            ),
            child: Text('Cerrar Sesión', style: AppEs.bdS.copyWith(color: AppCSS.F)),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        await _limpiarCache();
        await AuthServicio.logout();
        if (mounted) {
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const PantallaLogin()),
            (r) => false);
        }
      } catch (e) {
        if (mounted) Msg.er(context, 'Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _fotoCtrl.dispose();
    super.dispose();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../wiauth/auth_fb.dart';

// 🔥 SERVICIO FIRESTORE WINWII _______
// Cache 3 niveles: memoria → storage → firestore
// Filtro por email del usuario logueado

final _db = FirebaseFirestore.instance;

class WiiDB {
  // 🧠 Cache en memoria _______
  static final Map<String, List<Map<String, dynamic>>> _mem = {};
  static final Map<String, DateTime> _memT = {};
  static const _exp = Duration(hours: 2);

  // 📧 Email del usuario actual _______
  static String get _email => AuthServicio.usuarioActual?.email ?? '';

  // 🔑 Key para cache storage _______
  static String _kS(String col) => 'wii_${col}_$_email';
  static String _kT(String col) => 'wii_${col}_t_$_email';

  // ═══════════════════════════════════════════════════════════
  // 📖 LEER - Cache 3 niveles
  // ═══════════════════════════════════════════════════════════

  /// Obtener datos de una colección filtrados por email
  /// 1. Memoria → 2. Storage → 3. Firestore
  static Future<List<Map<String, dynamic>>> get(String col) async {
    if (_email.isEmpty) return [];

    // 1️⃣ Memoria
    if (_memOk(col)) return _mem[col]!;

    // 2️⃣ Storage
    final sto = await _deStorage(col);
    if (sto != null) {
      _mem[col] = sto;
      return sto;
    }

    // 3️⃣ Firestore
    return await _deFB(col);
  }

  /// Obtener con filtro extra (ej: semana == '2026-02-16')
  static Future<List<Map<String, dynamic>>> getWhere(
    String col, String campo, dynamic valor,
  ) async {
    if (_email.isEmpty) return [];
    final key = '${col}_${campo}_$valor';

    // 1️⃣ Memoria
    if (_memOk(key)) return _mem[key]!;

    // 2️⃣ Storage
    final sto = await _deStorage(key);
    if (sto != null) {
      _mem[key] = sto;
      return sto;
    }

    // 3️⃣ Firestore con filtro
    return await _deFBWhere(col, campo, valor, key);
  }

  /// Obtener por rango de fechas (para meses)
  static Future<List<Map<String, dynamic>>> getR(
    String col, String campo, String desde, String hasta,
  ) async {
    if (_email.isEmpty) return [];
    final key = '${col}_${campo}_${desde}_$hasta';

    // 1️⃣ Memoria
    if (_memOk(key)) return _mem[key]!;

    // 2️⃣ Storage
    final sto = await _deStorage(key);
    if (sto != null) {
      _mem[key] = sto;
      return sto;
    }

    // 3️⃣ Firestore rango
    return await _deFBR(col, campo, desde, hasta, key);
  }

  // ═══════════════════════════════════════════════════════════
  // ✏️ ESCRIBIR - Upsert (crear o actualizar)
  // ═══════════════════════════════════════════════════════════

  /// Guardar documento (si existe actualiza, si no crea)
  static Future<void> upsert(String col, String id, Map<String, dynamic> data) async {
    if (_email.isEmpty) return;

    data['email'] = _email;
    data['actualizado'] = FieldValue.serverTimestamp();

    await _db.collection(col).doc(id).set(data, SetOptions(merge: true));

    // Invalidar cache de esa colección
    _invalidar(col);
  }

  /// Toggle campo boolean (ej: done, completado)
  static Future<void> toggle(String col, String id, String campo, bool valor) async {
    if (_email.isEmpty) return;

    await _db.collection(col).doc(id).update({
      campo: valor,
      'actualizado': FieldValue.serverTimestamp(),
    });

    // Actualizar en memoria si existe
    _actualizarMem(col, id, {campo: valor});
  }

  /// Actualizar campos específicos
  static Future<void> update(String col, String id, Map<String, dynamic> campos) async {
    if (_email.isEmpty) return;

    campos['actualizado'] = FieldValue.serverTimestamp();
    await _db.collection(col).doc(id).update(campos);

    _actualizarMem(col, id, campos);
  }

  // ═══════════════════════════════════════════════════════════
  // 🗑️ ELIMINAR
  // ═══════════════════════════════════════════════════════════

  static Future<void> del(String col, String id) async {
    if (_email.isEmpty) return;

    await _db.collection(col).doc(id).delete();
    _invalidar(col);
  }

  // ═══════════════════════════════════════════════════════════
  // 🔄 FORZAR RECARGA (pull to refresh)
  // ═══════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> refresh(String col) async {
    _invalidar(col);
    return await _deFB(col);
  }

  static Future<List<Map<String, dynamic>>> refreshWhere(
    String col, String campo, dynamic valor,
  ) async {
    final key = '${col}_${campo}_$valor';
    _invalidarKey(key);
    return await _deFBWhere(col, campo, valor, key);
  }

  static Future<List<Map<String, dynamic>>> refreshR(
    String col, String campo, String desde, String hasta,
  ) async {
    final key = '${col}_${campo}_${desde}_$hasta';
    _invalidarKey(key);
    return await _deFBR(col, campo, desde, hasta, key);
  }

  // ═══════════════════════════════════════════════════════════
  // 🧹 LIMPIAR CACHE
  // ═══════════════════════════════════════════════════════════

  static Future<void> limpiar() async {
    _mem.clear();
    _memT.clear();
    try {
      final p = await SharedPreferences.getInstance();
      final keys = p.getKeys().where((k) => k.startsWith('wii_'));
      for (final k in keys) {
        await p.remove(k);
      }
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════════
  // 🔧 INTERNOS - Firestore
  // ═══════════════════════════════════════════════════════════

  /// Query base: email == _email, ordenado por actualizado desc
  static Future<List<Map<String, dynamic>>> _deFB(String col) async {
    try {
      final snap = await _db.collection(col)
          .where('email', isEqualTo: _email)
          .orderBy('actualizado', descending: true)
          .get();

      final data = snap.docs.map((d) => _docToMap(d)).toList();
      await _guardar(col, data);
      return data;
    } catch (e) {
      // Si falla orderBy (necesita índice), intentar sin orden
      try {
        final snap = await _db.collection(col)
            .where('email', isEqualTo: _email)
            .get();
        final data = snap.docs.map((d) => _docToMap(d)).toList();
        await _guardar(col, data);
        return data;
      } catch (_) {
        return [];
      }
    }
  }

  /// Query con filtro extra
  static Future<List<Map<String, dynamic>>> _deFBWhere(
    String col, String campo, dynamic valor, String key,
  ) async {
    try {
      final snap = await _db.collection(col)
          .where('email', isEqualTo: _email)
          .where(campo, isEqualTo: valor)
          .get();

      final data = snap.docs.map((d) => _docToMap(d)).toList();
      await _guardar(key, data);
      return data;
    } catch (_) {
      return [];
    }
  }

  /// Query por rango
  static Future<List<Map<String, dynamic>>> _deFBR(
    String col, String campo, String desde, String hasta, String key,
  ) async {
    try {
      final snap = await _db.collection(col)
          .where('email', isEqualTo: _email)
          .where(campo, isGreaterThanOrEqualTo: desde)
          .where(campo, isLessThanOrEqualTo: hasta)
          .get();

      final data = snap.docs.map((d) => _docToMap(d)).toList();
      await _guardar(key, data);
      return data;
    } catch (_) {
      return [];
    }
  }

  /// Convertir DocumentSnapshot → Map limpio
  static Map<String, dynamic> _docToMap(DocumentSnapshot d) {
    final data = d.data() as Map<String, dynamic>? ?? {};
    data['_id'] = d.id;

    // Convertir Timestamps a String ISO
    data.forEach((k, v) {
      if (v is Timestamp) {
        data[k] = v.toDate().toIso8601String();
      }
    });

    return data;
  }

  // ═══════════════════════════════════════════════════════════
  // 🔧 INTERNOS - Cache
  // ═══════════════════════════════════════════════════════════

  static bool _memOk(String key) =>
      _mem.containsKey(key) &&
      _memT.containsKey(key) &&
      DateTime.now().difference(_memT[key]!) < _exp;

  static Future<void> _guardar(String key, List<Map<String, dynamic>> data) async {
    // Memoria
    _mem[key] = data;
    _memT[key] = DateTime.now();

    // Storage
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kS(key), jsonEncode(data));
      await p.setString(_kT(key), DateTime.now().toIso8601String());
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>?> _deStorage(String key) async {
    try {
      final p = await SharedPreferences.getInstance();
      final j = p.getString(_kS(key));
      final t = p.getString(_kT(key));
      if (j == null || t == null) return null;

      final fecha = DateTime.parse(t);
      if (DateTime.now().difference(fecha) > _exp) return null;

      _memT[key] = fecha;
      final list = (jsonDecode(j) as List).cast<Map<String, dynamic>>();
      return list;
    } catch (_) {
      return null;
    }
  }

  static void _invalidar(String col) {
    // Invalida la colección base y todas las keys derivadas
    final keysToRemove = _mem.keys.where((k) => k == col || k.startsWith('${col}_')).toList();
    for (final k in keysToRemove) {
      _mem.remove(k);
      _memT.remove(k);
    }
  }

  static void _invalidarKey(String key) {
    _mem.remove(key);
    _memT.remove(key);
  }

  /// Actualizar item en todas las caches de memoria que contengan ese id
  static void _actualizarMem(String col, String id, Map<String, dynamic> campos) {
    for (final entry in _mem.entries) {
      if (entry.key == col || entry.key.startsWith('${col}_')) {
        for (final item in entry.value) {
          if (item['_id'] == id || item['id'] == id) {
            item.addAll(campos);
            break;
          }
        }
      }
    }
  }
}
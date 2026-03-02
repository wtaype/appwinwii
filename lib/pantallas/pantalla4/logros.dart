import 'package:flutter/material.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../firebase.dart';

// 🏆 COLECCIÓN: 'logros' _______
const _colLog = 'logros';

// Categorías (mismo que logros.js CATEGORIAS)
const _catLogro = {
  'personal':  {'lbl': 'Personal',  'ico': Icons.person, 'clr': Color(0xFFFFB800)},
  'trabajo':   {'lbl': 'Trabajo',   'ico': Icons.work, 'clr': Color(0xFF0EBEFF)},
  'estudio':   {'lbl': 'Estudio',   'ico': Icons.book, 'clr': Color(0xFF7000FF)},
  'salud':     {'lbl': 'Salud',     'ico': Icons.favorite, 'clr': Color(0xFFFF5C69)},
  'deporte':   {'lbl': 'Deporte',   'ico': Icons.fitness_center, 'clr': Color(0xFF29C72E)},
  'finanzas':  {'lbl': 'Finanzas',  'ico': Icons.monetization_on, 'clr': Color(0xFF00C9B1)},
  'social':    {'lbl': 'Social',    'ico': Icons.people, 'clr': Color(0xFFA855F7)},
  'creativo':  {'lbl': 'Creativo',  'ico': Icons.palette, 'clr': Color(0xFFF97316)},
  'otro':      {'lbl': 'Otro',      'ico': Icons.star, 'clr': Color(0xFF94A3B8)},
};

// XP por categoría (mismo que logros.js XP_CAT)
const _xpCat = {
  'personal': 15, 'trabajo': 20, 'estudio': 25, 'salud': 18,
  'deporte': 20, 'finanzas': 15, 'social': 12, 'creativo': 18, 'otro': 10,
};

// Niveles (mismo que logros.js NIVELES)
const _niveles = [
  {'min': 0,    'max': 100,  'lbl': 'Novato',   'ico': Icons.eco, 'clr': Color(0xFF94A3B8), 'badge': '🌱'},
  {'min': 100,  'max': 300,  'lbl': 'Aprendiz', 'ico': Icons.bolt, 'clr': Color(0xFF29C72E), 'badge': '⚡'},
  {'min': 300,  'max': 600,  'lbl': 'Veterano', 'ico': Icons.shield, 'clr': Color(0xFF0EBEFF), 'badge': '🛡️'},
  {'min': 600,  'max': 1000, 'lbl': 'Experto',  'ico': Icons.diamond, 'clr': Color(0xFF7000FF), 'badge': '💎'},
  {'min': 1000, 'max': 2000, 'lbl': 'Maestro',  'ico': Icons.workspace_premium, 'clr': Color(0xFFFFB800), 'badge': '👑'},
  {'min': 2000, 'max': 9999, 'lbl': 'Leyenda',  'ico': Icons.local_fire_department, 'clr': Color(0xFFFF5C69), 'badge': '🔥'},
];

// 📋 COLECCIÓN: 'planes' _______
const _colPlan = 'planes';

const _catPlan = {
  'personal':  {'lbl': 'Personal',  'ico': Icons.person, 'clr': Color(0xFFFFB800)},
  'trabajo':   {'lbl': 'Trabajo',   'ico': Icons.work, 'clr': Color(0xFF0EBEFF)},
  'estudio':   {'lbl': 'Estudio',   'ico': Icons.book, 'clr': Color(0xFF7000FF)},
  'salud':     {'lbl': 'Salud',     'ico': Icons.favorite, 'clr': Color(0xFFFF5C69)},
  'finanzas':  {'lbl': 'Finanzas',  'ico': Icons.monetization_on, 'clr': Color(0xFF29C72E)},
  'viaje':     {'lbl': 'Viaje',     'ico': Icons.flight, 'clr': Color(0xFF00C9B1)},
  'proyecto':  {'lbl': 'Proyecto',  'ico': Icons.account_tree, 'clr': Color(0xFFA855F7)},
  'otro':      {'lbl': 'Otro',      'ico': Icons.circle, 'clr': Color(0xFF94A3B8)},
};

const _prioPlan = {
  'alta':  {'lbl': 'Alta',  'clr': Color(0xFFFF5C69), 'ico': Icons.arrow_upward},
  'media': {'lbl': 'Media', 'clr': Color(0xFFFFB800), 'ico': Icons.remove},
  'baja':  {'lbl': 'Baja',  'clr': Color(0xFF29C72E), 'ico': Icons.arrow_downward},
};

const _estPlan = {
  'activo':     {'lbl': 'Activo',     'ico': Icons.play_circle, 'clr': Color(0xFF0EBEFF)},
  'pausado':    {'lbl': 'Pausado',    'ico': Icons.pause_circle, 'clr': Color(0xFFFFB800)},
  'completado': {'lbl': 'Completado', 'ico': Icons.check_circle, 'clr': Color(0xFF29C72E)},
  'cancelado':  {'lbl': 'Cancelado',  'ico': Icons.cancel, 'clr': Color(0xFF94A3B8)},
};

// ═══════════════════════════════════════════════════════════════
// 🏆 PANTALLA LOGROS (con sub-tabs: Logros + Planes)
// ═══════════════════════════════════════════════════════════════
class PantallaLogros extends StatefulWidget {
  const PantallaLogros({super.key});

  @override
  State<PantallaLogros> createState() => _PantallaLogrosState();
}

class _PantallaLogrosState extends State<PantallaLogros> with SingleTickerProviderStateMixin {
  late final TabController tabC;

  @override
  void initState() {
    super.initState();
    tabC = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext ctx) => SafeArea(
    child: Column(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppCSS.F.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppCSS.rM),
          border: Border.all(color: AppCSS.brd.withOpacity(0.5)),
        ),
        child: TabBar(
          controller: tabC,
          indicator: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFFB800)]),
            borderRadius: BorderRadius.circular(AppCSS.rS),
          ),
          labelColor: AppCSS.F,
          unselectedLabelColor: AppCSS.tx2,
          labelStyle: AppEs.bdS.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppEs.bdS,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: AppCSS.O,
          tabs: const [
            Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.emoji_events, size: 16), SizedBox(width: 6), Text('Logros'),
            ])),
            Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.rocket_launch, size: 16), SizedBox(width: 6), Text('Planes'),
            ])),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: tabC,
          children: const [_VistaLogros(), _VistaPlanes()],
        ),
      ),
    ]),
  );

  @override
  void dispose() { tabC.dispose(); super.dispose(); }
}

// ═══════════════════════════════════════════════════════════════
// 🏆 TAB 1: VISTA LOGROS
// ═══════════════════════════════════════════════════════════════
class _VistaLogros extends StatefulWidget {
  const _VistaLogros();
  @override
  State<_VistaLogros> createState() => _VistaLogrosState();
}

class _VistaLogrosState extends State<_VistaLogros> {
  List<Map<String, dynamic>> items = [];
  bool load = true;
  String filtCat = 'todas';

  @override
  void initState() { super.initState(); _cargar(); }

  Future<void> _cargar() async {
    setState(() => load = true);
    try { items = await WiiDB.get(_colLog); }
    catch (e) { if (mounted) Msg.er(context, 'Error: $e'); }
    finally { if (mounted) setState(() => load = false); }
  }

  Future<void> _recargar() async {
    setState(() => load = true);
    try {
      items = await WiiDB.refresh(_colLog);
      if (mounted) Msg.ok(context, 'Logros actualizados 🔄');
    } catch (e) { if (mounted) Msg.er(context, 'Error: $e'); }
    finally { if (mounted) setState(() => load = false); }
  }

  List<Map<String, dynamic>> get _filtrados {
    var list = List<Map<String, dynamic>>.from(items);
    // Destacados primero, luego por fecha desc
    list.sort((a, b) {
      if (a['destacado'] == true && b['destacado'] != true) return -1;
      if (b['destacado'] == true && a['destacado'] != true) return 1;
      return (b['fecha'] ?? '').compareTo(a['fecha'] ?? '');
    });
    if (filtCat == 'todas') return list;
    if (filtCat == 'destacado') return list.where((l) => l['destacado'] == true).toList();
    return list.where((l) => l['categoria'] == filtCat).toList();
  }

  int get _total => items.length;
  int get _dest => items.where((l) => l['destacado'] == true).length;

  // XP system (igual que logros.js)
  int get _xp => items.fold(0, (acc, l) {
    final base = _xpCat[l['categoria']] ?? 10;
    final extra = l['destacado'] == true ? 10 : 0;
    return acc + base + extra;
  });

  int _xpItem(Map<String, dynamic> l) => (_xpCat[l['categoria']] ?? 10) + (l['destacado'] == true ? 10 : 0);

  Map<String, dynamic> get _nivel {
    final xp = _xp;
    for (final n in _niveles) {
      if (xp >= (n['min'] as int) && xp < (n['max'] as int)) return n;
    }
    return _niveles.last;
  }

  Map<String, dynamic> get _nivelSig {
    final xp = _xp;
    for (final n in _niveles) {
      if ((n['min'] as int) > xp) return n;
    }
    return _niveles.last;
  }

  double get _xpPct {
    final n = _nivel;
    final sig = _nivelSig;
    final min = n['min'] as int;
    final max = sig['min'] as int;
    if (min == max) return 1.0;
    return ((_xp - min) / (max - min)).clamp(0.0, 1.0);
  }

  Future<void> _eliminar(Map<String, dynamic> item) async {
    final id = item['_id'] as String? ?? item['id'] as String? ?? '';
    if (id.isEmpty) return;
    setState(() => items.remove(item));
    try {
      await WiiDB.del(_colLog, id);
      if (mounted) Msg.ok(context, 'Logro eliminado ✅');
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
      _cargar();
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (load) return const Load(msg: 'Cargando logros...');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _hero(),
        AppCSS.gm,
        _filtros(),
        AppCSS.gm,
        _lista(),
      ]),
    );
  }

  // ── Hero con XP y nivel (como logros.js log_hero) ──
  Widget _hero() {
    final niv = _nivel;
    final clr = niv['clr'] as Color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [clr.withOpacity(0.15), clr.withOpacity(0.05)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppCSS.rL),
        border: Border.all(color: clr.withOpacity(0.3)),
      ),
      child: Column(children: [
        Row(children: [
          // Avatar nivel
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: clr.withOpacity(0.15),
              border: Border.all(color: clr.withOpacity(0.4), width: 2),
            ),
            child: Icon(niv['ico'] as IconData, size: 26, color: clr),
          ),
          AppCSS.ghm,
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Nivel: ', style: AppEs.sm),
              Text(niv['lbl'] as String, style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text(niv['badge'] as String, style: AppEs.bdS),
            ]),
            const SizedBox(height: 2),
            Text('$_xp XP · siguiente: ${_nivelSig['lbl']} (${_nivelSig['min']} XP)', style: AppEs.sm),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _xpPct, minHeight: 6,
                backgroundColor: AppCSS.brd.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(clr),
              ),
            ),
          ])),
          IconButton(icon: const Icon(Icons.refresh, color: AppCSS.mco, size: 18), onPressed: _recargar),
        ]),
        const SizedBox(height: 12),
        // Stats
        Row(children: [
          _heroStat('$_total', 'Logros', Icons.emoji_events, const Color(0xFFFFB800)),
          AppCSS.ghs,
          _heroStat('$_dest', 'Destacados', Icons.star, const Color(0xFFFF5C69)),
          AppCSS.ghs,
          _heroStat('$_xp', 'XP', Icons.bolt, const Color(0xFF0EBEFF)),
        ]),
      ]),
    );
  }

  Widget _heroStat(String val, String lbl, IconData ico, Color clr) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppCSS.F.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppCSS.rS),
      ),
      child: Column(children: [
        Icon(ico, size: 18, color: clr),
        const SizedBox(height: 2),
        Text(val, style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
        Text(lbl, style: AppEs.sm),
      ]),
    ),
  );

  Widget _filtros() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [
      _filtroChip('todas', 'Todos', Icons.layers, AppCSS.mco),
      _filtroChip('destacado', '⭐ Top', Icons.star, const Color(0xFFFFB800)),
      ..._catLogro.entries.take(5).map((e) => _filtroChip(
        e.key, e.value['lbl'] as String, e.value['ico'] as IconData, e.value['clr'] as Color,
      )),
    ]),
  );

  Widget _filtroChip(String key, String lbl, IconData ico, Color clr) {
    final sel = filtCat == key;
    return GestureDetector(
      onTap: () => setState(() => filtCat = key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? clr.withOpacity(0.15) : AppCSS.F.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppCSS.rS),
          border: Border.all(color: sel ? clr : AppCSS.brd.withOpacity(0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(ico, size: 14, color: sel ? clr : AppCSS.grs),
          const SizedBox(width: 4),
          Text(lbl, style: AppEs.sm.copyWith(
            color: sel ? clr : AppCSS.tx2, fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
          )),
        ]),
      ),
    );
  }

  Widget _lista() {
    final data = _filtrados;
    if (data.isEmpty) {
      return Vacio(
        msg: 'Sin logros aún\n¡Registra tu primer logro!',
        ico: Icons.emoji_events,
        txtBtn: 'Nuevo logro',
        onTap: () { /* TODO */ },
      );
    }
    return Column(children: data.map((l) => _logroCard(l)).toList());
  }

  Widget _logroCard(Map<String, dynamic> l) {
    final cat = _catLogro[l['categoria']] ?? _catLogro['otro']!;
    final clr = l['color'] != null
        ? Color(int.parse('0xFF${(l['color'] as String).replaceAll('#', '')}'))
        : cat['clr'] as Color;
    final esDest = l['destacado'] == true;
    final xp = _xpItem(l);

    return Container(
      margin: const EdgeInsets.only(bottom: AppCSS.s),
      decoration: BoxDecoration(
        color: AppCSS.F.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppCSS.rL),
        border: Border.all(color: esDest ? const Color(0xFFFFB800).withOpacity(0.4) : clr.withOpacity(0.3)),
      ),
      child: Column(children: [
        if (esDest) Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB800).withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12),
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.star, size: 12, color: Color(0xFFFFB800)),
            const SizedBox(width: 4),
            Text('Destacado', style: AppEs.sm.copyWith(color: const Color(0xFFFFB800), fontWeight: FontWeight.w600)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: clr.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppCSS.rM),
              ),
              child: Icon(cat['ico'] as IconData, size: 22, color: clr),
            ),
            AppCSS.ghm,
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l['titulo'] ?? '', style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
              if (l['descripcion'] != null && (l['descripcion'] as String).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(l['descripcion'], style: AppEs.sm, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              const SizedBox(height: 4),
              Wrap(spacing: 6, runSpacing: 4, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: clr.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(cat['ico'] as IconData, size: 10, color: clr),
                    const SizedBox(width: 3),
                    Text(cat['lbl'] as String, style: AppEs.sm.copyWith(color: clr)),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: clr.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text('+$xp XP', style: AppEs.sm.copyWith(color: clr, fontWeight: FontWeight.w600)),
                ),
                if (l['fecha'] != null) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppCSS.grs.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.calendar_today, size: 10, color: AppCSS.tx3),
                    const SizedBox(width: 3),
                    Text(_fmtFecha(l['fecha']), style: AppEs.sm),
                  ]),
                ),
              ]),
            ])),
            Column(children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 16, color: AppCSS.grs),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () { /* TODO: Editar logro */ },
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: AppCSS.cTar),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => _confirmarEliminar(l),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Future<void> _confirmarEliminar(Map<String, dynamic> l) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar logro', style: AppEs.h3),
        content: Text('¿Eliminar "${l['titulo']}"?', style: AppEs.bd),
        backgroundColor: AppCSS.F,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: AppEs.bdS.copyWith(color: AppCSS.grs))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppCSS.err,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rS))),
            child: Text('Eliminar', style: AppEs.bdS.copyWith(color: AppCSS.F))),
        ],
      ),
    );
    if (ok == true) _eliminar(l);
  }

  String _fmtFecha(String f) {
    try {
      final d = DateTime.parse(f);
      const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
      return '${d.day} ${meses[d.month - 1]} ${d.year}';
    } catch (_) { return f; }
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 TAB 2: VISTA PLANES (sincronizado con planes.js)
// ═══════════════════════════════════════════════════════════════
class _VistaPlanes extends StatefulWidget {
  const _VistaPlanes();
  @override
  State<_VistaPlanes> createState() => _VistaPlanesState();
}

class _VistaPlanesState extends State<_VistaPlanes> {
  List<Map<String, dynamic>> items = [];
  bool load = true;
  String filtro = 'todos';

  @override
  void initState() { super.initState(); _cargar(); }

  Future<void> _cargar() async {
    setState(() => load = true);
    try { items = await WiiDB.get(_colPlan); }
    catch (e) { if (mounted) Msg.er(context, 'Error: $e'); }
    finally { if (mounted) setState(() => load = false); }
  }

  Future<void> _recargar() async {
    setState(() => load = true);
    try {
      items = await WiiDB.refresh(_colPlan);
      if (mounted) Msg.ok(context, 'Planes actualizados 🔄');
    } catch (e) { if (mounted) Msg.er(context, 'Error: $e'); }
    finally { if (mounted) setState(() => load = false); }
  }

  List<Map<String, dynamic>> get _filtrados {
    var list = List<Map<String, dynamic>>.from(items);
    if (filtro != 'todos') list = list.where((p) => p['estado'] == filtro || p['categoria'] == filtro).toList();
    // Ordenar por prioridad
    list.sort((a, b) {
      final pa = {'alta': 0, 'media': 1, 'baja': 2};
      return (pa[a['prioridad']] ?? 1).compareTo(pa[b['prioridad']] ?? 1);
    });
    return list;
  }

  int get _total => items.length;
  int _countEst(String e) => items.where((p) => p['estado'] == e).length;

  int _pct(Map<String, dynamic> p) {
    final pasos = (p['pasos'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final done = pasos.where((s) => s['done'] == true).length;
    if (pasos.isNotEmpty) return (done * 100 ~/ pasos.length);
    return p['estado'] == 'completado' ? 100 : 0;
  }

  Future<void> _completar(Map<String, dynamic> p) async {
    final id = p['_id'] as String? ?? p['id'] as String? ?? '';
    if (id.isEmpty) return;

    // Marcar todos los pasos como done (como en planes.js _completar)
    final pasos = (p['pasos'] as List?)?.map((s) => {...(s as Map<String, dynamic>), 'done': true}).toList() ?? [];

    setState(() {
      p['estado'] = 'completado';
      p['pasos'] = pasos;
    });

    try {
      await WiiDB.update(_colPlan, id, {
        'estado': 'completado',
        'pasos': pasos,
        'completadoEn': DateTime.now().toIso8601String(),
      });
      if (mounted) Msg.ok(context, '🎉 ¡Plan completado!');
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
      _cargar();
    }
  }

  Future<void> _eliminar(Map<String, dynamic> p) async {
    final id = p['_id'] as String? ?? p['id'] as String? ?? '';
    if (id.isEmpty) return;
    setState(() => items.remove(p));
    try {
      await WiiDB.del(_colPlan, id);
      if (mounted) Msg.ok(context, 'Plan eliminado ✅');
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
      _cargar();
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (load) return const Load(msg: 'Cargando planes...');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _header(),
        AppCSS.gs,
        _stats(),
        AppCSS.gm,
        _filtros(),
        AppCSS.gm,
        _lista(),
      ]),
    );
  }

  Widget _header() => Glass(child: Row(children: [
    Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppCSS.gDia,
        borderRadius: BorderRadius.circular(AppCSS.rM),
      ),
      child: const Icon(Icons.rocket_launch, color: AppCSS.F, size: 22),
    ),
    AppCSS.ghm,
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Mis Planes', style: AppEs.h3),
      Text('$_total planes', style: AppEs.sm),
    ])),
    IconButton(icon: const Icon(Icons.refresh, color: AppCSS.mco, size: 20), onPressed: _recargar),
    IconButton(
      icon: const Icon(Icons.add, color: AppCSS.mco, size: 20),
      onPressed: () { /* TODO: Abrir modal nuevo plan */ },
    ),
  ]));

  Widget _stats() => Row(children: [
    _statChip('${_countEst('activo')}', 'Activos', Icons.play_circle, const Color(0xFF0EBEFF)),
    AppCSS.ghs,
    _statChip('${_countEst('pausado')}', 'Pausados', Icons.pause_circle, const Color(0xFFFFB800)),
    AppCSS.ghs,
    _statChip('${_countEst('completado')}', 'Hechos', Icons.check_circle, const Color(0xFF29C72E)),
  ]);

  Widget _statChip(String val, String lbl, IconData ico, Color clr) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: AppCSS.gCard,
      child: Column(children: [
        Icon(ico, size: 18, color: clr),
        const SizedBox(height: 2),
        Text(val, style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
        Text(lbl, style: AppEs.sm),
      ]),
    ),
  );

  Widget _filtros() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [
      _filtroChip('todos', 'Todos', Icons.layers, AppCSS.mco),
      ..._estPlan.entries.map((e) => _filtroChip(
        e.key, e.value['lbl'] as String, e.value['ico'] as IconData, e.value['clr'] as Color,
      )),
    ]),
  );

  Widget _filtroChip(String key, String lbl, IconData ico, Color clr) {
    final sel = filtro == key;
    return GestureDetector(
      onTap: () => setState(() => filtro = key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? clr.withOpacity(0.15) : AppCSS.F.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppCSS.rS),
          border: Border.all(color: sel ? clr : AppCSS.brd.withOpacity(0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(ico, size: 14, color: sel ? clr : AppCSS.grs),
          const SizedBox(width: 4),
          Text(lbl, style: AppEs.sm.copyWith(
            color: sel ? clr : AppCSS.tx2, fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
          )),
        ]),
      ),
    );
  }

  Widget _lista() {
    final data = _filtrados;
    if (data.isEmpty) {
      return Vacio(
        msg: 'Sin planes\nCrea tu primer plan',
        ico: Icons.rocket_launch,
        txtBtn: 'Nuevo plan',
        onTap: () { /* TODO */ },
      );
    }
    return Column(children: data.map((p) => _planCard(p)).toList());
  }

  Widget _planCard(Map<String, dynamic> p) {
    final cat = _catPlan[p['categoria']] ?? _catPlan['otro']!;
    final est = _estPlan[p['estado']] ?? _estPlan['activo']!;
    final prio = _prioPlan[p['prioridad']] ?? _prioPlan['media']!;
    final clr = p['color'] != null
        ? Color(int.parse('0xFF${(p['color'] as String).replaceAll('#', '')}'))
        : cat['clr'] as Color;
    final completado = p['estado'] == 'completado';
    final progreso = _pct(p);
    final pasos = (p['pasos'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final pasosDone = pasos.where((s) => s['done'] == true).length;

    return Container(
      margin: const EdgeInsets.only(bottom: AppCSS.s),
      decoration: BoxDecoration(
        color: completado ? AppCSS.F.withOpacity(0.5) : AppCSS.F.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppCSS.rL),
        border: Border.all(color: clr.withOpacity(0.3)),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: clr,
                  borderRadius: BorderRadius.circular(AppCSS.rS),
                ),
                child: Icon(cat['ico'] as IconData, size: 20, color: AppCSS.F),
              ),
              AppCSS.ghs,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['titulo'] ?? '', style: AppEs.bdS.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: completado ? TextDecoration.lineThrough : null,
                  color: completado ? AppCSS.grs : AppCSS.tx1,
                )),
                const SizedBox(height: 4),
                Wrap(spacing: 6, runSpacing: 4, children: [
                  _badge(est['ico'] as IconData, est['lbl'] as String, est['clr'] as Color),
                  _badge(prio['ico'] as IconData, prio['lbl'] as String, prio['clr'] as Color),
                  _badge(cat['ico'] as IconData, cat['lbl'] as String, clr),
                ]),
              ])),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18, color: AppCSS.grs),
                onSelected: (v) {
                  if (v == 'edit') { /* TODO: Editar plan */ }
                  if (v == 'del') _confirmarEliminar(p);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [
                    Icon(Icons.edit, size: 16, color: AppCSS.grs), SizedBox(width: 6), Text('Editar'),
                  ])),
                  const PopupMenuItem(value: 'del', child: Row(children: [
                    Icon(Icons.delete, size: 16, color: AppCSS.cTar), SizedBox(width: 6), Text('Eliminar'),
                  ])),
                ],
              ),
            ]),
            // Descripción
            if (p['descripcion'] != null && (p['descripcion'] as String).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(p['descripcion'], style: AppEs.sm, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            // Progreso
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Progreso', style: AppEs.sm.copyWith(fontWeight: FontWeight.w500)),
              Text('$progreso%', style: AppEs.sm.copyWith(color: clr, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progreso / 100, minHeight: 6,
                backgroundColor: AppCSS.brd.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(clr),
              ),
            ),
            // Pasos preview
            if (pasos.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...pasos.take(3).map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(children: [
                  Icon(
                    s['done'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 14, color: s['done'] == true ? AppCSS.ok : AppCSS.grs,
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(s['txt'] ?? '', style: AppEs.sm.copyWith(
                    decoration: s['done'] == true ? TextDecoration.lineThrough : null,
                    color: s['done'] == true ? AppCSS.grs : AppCSS.tx2,
                  ), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
              )),
              if (pasos.length > 3)
                Text('+${pasos.length - 3} más', style: AppEs.sm.copyWith(color: AppCSS.tx3)),
            ],
          ]),
        ),
        // Footer: fechas + completar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppCSS.brd.withOpacity(0.3)))),
          child: Row(children: [
            if (p['inicio'] != null && (p['inicio'] as String).isNotEmpty) ...[
              const Icon(Icons.play_arrow, size: 12, color: AppCSS.tx3),
              const SizedBox(width: 2),
              Text(_fmtFecha(p['inicio']), style: AppEs.sm),
              const SizedBox(width: 8),
            ],
            if (p['meta'] != null && (p['meta'] as String).isNotEmpty) ...[
              const Icon(Icons.flag, size: 12, color: AppCSS.tx3),
              const SizedBox(width: 2),
              Text(_fmtFecha(p['meta']), style: AppEs.sm),
              const SizedBox(width: 4),
              _diasRest(p['meta']),
            ],
            const Spacer(),
            if (!completado)
              GestureDetector(
                onTap: () => _completar(p),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppCSS.ok.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppCSS.rS),
                    border: Border.all(color: AppCSS.ok.withOpacity(0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.check, size: 14, color: AppCSS.ok),
                    const SizedBox(width: 4),
                    Text('Completar', style: AppEs.sm.copyWith(color: AppCSS.ok, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
          ]),
        ),
      ]),
    );
  }

  Widget _badge(IconData ico, String lbl, Color clr) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: clr.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(ico, size: 10, color: clr),
      const SizedBox(width: 3),
      Text(lbl, style: AppEs.sm.copyWith(color: clr)),
    ]),
  );

  Widget _diasRest(String f) {
    try {
      final hoy = DateTime.now();
      final hoyStr = '${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
      final diff = DateTime.parse(f).difference(DateTime.parse(hoyStr)).inDays;
      if (diff < 0) {
        return Text('${-diff}d atrás', style: AppEs.sm.copyWith(color: AppCSS.err, fontWeight: FontWeight.w600));
      } else if (diff == 0) {
        return Text('Hoy', style: AppEs.sm.copyWith(color: AppCSS.mco, fontWeight: FontWeight.w600));
      } else {
        return Text('${diff}d', style: AppEs.sm.copyWith(color: AppCSS.ok, fontWeight: FontWeight.w600));
      }
    } catch (_) { return const SizedBox.shrink(); }
  }

  Future<void> _confirmarEliminar(Map<String, dynamic> p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar plan', style: AppEs.h3),
        content: Text('¿Eliminar "${p['titulo']}"?', style: AppEs.bd),
        backgroundColor: AppCSS.F,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rM)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: AppEs.bdS.copyWith(color: AppCSS.grs))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppCSS.err,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCSS.rS))),
            child: Text('Eliminar', style: AppEs.bdS.copyWith(color: AppCSS.F))),
        ],
      ),
    );
    if (ok == true) _eliminar(p);
  }

  String _fmtFecha(String f) {
    try {
      final d = DateTime.parse(f);
      const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
      return '${d.day} ${meses[d.month - 1]} ${d.year}';
    } catch (_) { return f; }
  }
}
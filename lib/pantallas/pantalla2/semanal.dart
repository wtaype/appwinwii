import 'package:flutter/material.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../firebase.dart';

// 📆 COLECCIÓN _______
const _col = 'semanal';

const _dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
const _diasKey = ['lun', 'mar', 'mie', 'jue', 'vie', 'sab', 'dom'];

const _catSem = {
  'trabajo':  {'lbl': 'Trabajo',  'ico': Icons.work, 'clr': Color(0xFF0EBEFF)},
  'estudio':  {'lbl': 'Estudio',  'ico': Icons.book, 'clr': Color(0xFF7000FF)},
  'personal': {'lbl': 'Personal', 'ico': Icons.person, 'clr': Color(0xFFFFB800)},
  'salud':    {'lbl': 'Salud',    'ico': Icons.favorite, 'clr': Color(0xFFFF5C69)},
  'proyecto': {'lbl': 'Proyecto', 'ico': Icons.account_tree, 'clr': Color(0xFFA855F7)},
  'reunion':  {'lbl': 'Reunión',  'ico': Icons.groups, 'clr': Color(0xFF29C72E)},
  'otro':     {'lbl': 'Otro',     'ico': Icons.circle, 'clr': Color(0xFF94A3B8)},
};

const _prioSem = {
  'alta':  {'lbl': 'Alta',  'clr': Color(0xFFFF5C69), 'ico': Icons.arrow_upward},
  'media': {'lbl': 'Media', 'clr': Color(0xFFFFB800), 'ico': Icons.remove},
  'baja':  {'lbl': 'Baja',  'clr': Color(0xFF29C72E), 'ico': Icons.arrow_downward},
};

class VistaSemanal extends StatefulWidget {
  const VistaSemanal({super.key});

  @override
  State<VistaSemanal> createState() => _VistaSemanalState();
}

class _VistaSemanalState extends State<VistaSemanal> {
  late DateTime lunes;
  Map<String, List<Map<String, dynamic>>> items = {};
  bool load = true;

  @override
  void initState() {
    super.initState();
    lunes = _getLunes(DateTime.now());
    _cargar();
  }

  DateTime _getLunes(DateTime d) {
    final dow = d.weekday;
    return DateTime(d.year, d.month, d.day - dow + 1);
  }

  String _fmtFecha(DateTime d) =>
      '${d.day} ${['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'][d.month - 1]}';

  String get _lunesStr =>
      '${lunes.year}-${lunes.month.toString().padLeft(2, '0')}-${lunes.day.toString().padLeft(2, '0')}';

  String get _rangoTxt => '${_fmtFecha(lunes)} — ${_fmtFecha(lunes.add(const Duration(days: 6)))}';

  bool _esHoy(int i) {
    final d = lunes.add(Duration(days: i));
    final h = DateTime.now();
    return d.year == h.year && d.month == h.month && d.day == h.day;
  }

  bool _esPasado(int i) {
    final d = lunes.add(Duration(days: i));
    final h = DateTime.now();
    return d.isBefore(DateTime(h.year, h.month, h.day));
  }

  int get _total => items.values.fold(0, (a, b) => a + b.length);
  int get _done => items.values.fold(0, (a, b) => a + b.where((x) => x['done'] == true).length);
  int get _pct => _total > 0 ? (_done * 100 ~/ _total) : 0;

  Future<void> _cargar() async {
    setState(() => load = true);
    try {
      final data = await WiiDB.getWhere(_col, 'semana', _lunesStr);
      _agrupar(data);
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  Future<void> _recargar() async {
    setState(() => load = true);
    try {
      final data = await WiiDB.refreshWhere(_col, 'semana', _lunesStr);
      _agrupar(data);
      if (mounted) Notificacion.ok(context, 'Semana actualizada 🔄');
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  void _agrupar(List<Map<String, dynamic>> data) {
    items = {for (var k in _diasKey) k: []};
    for (final d in data) {
      final dia = d['dia'] as String? ?? '';
      if (items.containsKey(dia)) {
        items[dia]!.add(d);
      }
    }
    // Ordenar cada día por hora
    for (final k in _diasKey) {
      items[k]!.sort((a, b) {
        final ha = a['hora'] as String? ?? '99:99';
        final hb = b['hora'] as String? ?? '99:99';
        return ha.compareTo(hb);
      });
    }
  }

  Future<void> _toggleDone(Map<String, dynamic> item) async {
    final id = item['_id'] as String? ?? item['id'] as String? ?? '';
    if (id.isEmpty) return;
    final nuevo = !(item['done'] == true);
    setState(() => item['done'] = nuevo);
    try {
      await WiiDB.toggle(_col, id, 'done', nuevo);
    } catch (e) {
      setState(() => item['done'] = !nuevo);
      if (mounted) Notificacion.err(context, 'Error: $e');
    }
  }

  Future<void> _eliminar(Map<String, dynamic> item) async {
    final id = item['_id'] as String? ?? item['id'] as String? ?? '';
    if (id.isEmpty) return;
    final dia = item['dia'] as String? ?? '';
    setState(() => items[dia]?.remove(item));
    try {
      await WiiDB.del(_col, id);
      if (mounted) Notificacion.ok(context, 'Eliminado ✅');
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
      _cargar(); // Recargar si falla
    }
  }

  void _cambiarSemana(int dir) {
    setState(() {
      lunes = lunes.add(Duration(days: 7 * dir));
    });
    _cargar();
  }

  @override
  Widget build(BuildContext ctx) {
    if (load) return const Load(msg: 'Cargando semana...');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _toolbar(),
        AppCSS.gs,
        _stats(),
        AppCSS.gm,
        ..._board(),
      ]),
    );
  }

  Widget _toolbar() => Glass(child: Row(children: [
    IconButton(
      icon: const Icon(Icons.chevron_left, color: AppCSS.mco),
      onPressed: () => _cambiarSemana(-1),
    ),
    Expanded(child: Column(children: [
      Text('Semana', style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600)),
      Text(_rangoTxt, style: AppEs.sm),
    ])),
    TextButton.icon(
      onPressed: () {
        setState(() => lunes = _getLunes(DateTime.now()));
        _cargar();
      },
      icon: const Icon(Icons.my_location, size: 14),
      label: Text('Hoy', style: AppEs.sm.copyWith(color: AppCSS.mco)),
    ),
    IconButton(
      icon: const Icon(Icons.refresh, color: AppCSS.mco, size: 18),
      onPressed: _recargar,
    ),
    IconButton(
      icon: const Icon(Icons.chevron_right, color: AppCSS.mco),
      onPressed: () => _cambiarSemana(1),
    ),
  ]));

  Widget _stats() => Row(children: [
    wiStat('$_total', 'Total', Icons.layers, AppCSS.mco, vertical: false),
    AppCSS.ghs,
    wiStat('$_done', 'Hechas', Icons.check_circle, AppCSS.bg2, vertical: false),
    AppCSS.ghs,
    wiStat('$_pct%', 'Avance', Icons.trending_up, AppCSS.bg1, vertical: false),
  ]);

  List<Widget> _board() {
    final ws = <Widget>[];
    for (var i = 0; i < 7; i++) {
      final key = _diasKey[i];
      final dia = _dias[i];
      final hoy = _esHoy(i);
      final past = _esPasado(i);
      final dItems = items[key] ?? [];
      final dDone = dItems.where((x) => x['done'] == true).length;

      ws.add(Container(
        margin: const EdgeInsets.only(bottom: AppCSS.s),
        decoration: BoxDecoration(
          color: hoy ? AppCSS.mco.withOpacity(0.08) : AppCSS.whi.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppCSS.rL),
          border: Border.all(color: hoy ? AppCSS.mco.withOpacity(0.3) : AppCSS.brd.withOpacity(0.5)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header día ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppCSS.brd.withOpacity(0.3))),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hoy ? AppCSS.mco : (past ? AppCSS.grs.withOpacity(0.2) : AppCSS.O),
                  borderRadius: BorderRadius.circular(AppCSS.rS),
                ),
                child: Text(dia, style: AppEs.bdS.copyWith(
                  fontWeight: FontWeight.w600,
                  color: hoy ? AppCSS.whi : (past ? AppCSS.grs : AppCSS.tx1),
                )),
              ),
              AppCSS.ghs,
              Text(_fmtFecha(lunes.add(Duration(days: i))), style: AppEs.sm),
              if (hoy) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppCSS.mco.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Hoy', style: AppEs.sm.copyWith(color: AppCSS.mco, fontWeight: FontWeight.w600)),
                ),
              ],
              const Spacer(),
              if (dItems.isNotEmpty) Text('$dDone/${dItems.length}', style: AppEs.sm),
              if (!past) IconButton(
                icon: const Icon(Icons.add, size: 18, color: AppCSS.mco),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: () {
                  // TODO: Abrir modal nueva actividad para día $key
                },
              ),
            ]),
          ),
          // ── Items ──
          if (dItems.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(past ? Icons.history : Icons.nightlight, size: 16, color: AppCSS.grs),
                const SizedBox(width: 6),
                Text(past ? 'Sin registros' : 'Vacío', style: AppEs.sm),
              ]),
            )
          else
            ...dItems.map((item) => _itemCard(item, past)),
          const SizedBox(height: 4),
        ]),
      ));
    }
    return ws;
  }

  Widget _itemCard(Map<String, dynamic> item, bool past) {
    final cat = _catSem[item['categoria']] ?? _catSem['otro']!;
    final clr = wicoHx(item['color'] as String?, cat['clr'] as Color);
    final done = item['done'] == true;
    final prio = _prioSem[item['prioridad']] ?? _prioSem['media']!;

    return Dismissible(
      key: Key(item['_id'] ?? item['id'] ?? '${item.hashCode}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppCSS.err.withOpacity(0.1),
        child: const Icon(Icons.delete, color: AppCSS.err),
      ),
      confirmDismiss: (_) async {
        final ok = await Mensaje(context, msg: '¿Eliminar "${item['titulo']}"?');
        if (ok == true) _eliminar(item);
        return false;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(children: [
          GestureDetector(
            onTap: () => _toggleDone(item),
            child: Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 22, color: done ? AppCSS.ok : clr,
            ),
          ),
          AppCSS.ghs,
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item['titulo'] ?? '', style: AppEs.bdS.copyWith(
              fontWeight: FontWeight.w500,
              decoration: done ? TextDecoration.lineThrough : null,
              color: done ? AppCSS.grs : AppCSS.tx1,
            )),
            if (item['nota'] != null && (item['nota'] as String).isNotEmpty)
              Text(item['nota'], style: AppEs.sm, maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(children: [
              if (item['hora'] != null && (item['hora'] as String).isNotEmpty) ...[
                Icon(Icons.schedule, size: 11, color: AppCSS.tx3),
                const SizedBox(width: 2),
                Text(item['hora'], style: AppEs.sm),
                const SizedBox(width: 6),
              ],
              Icon(cat['ico'] as IconData, size: 11, color: clr),
              const SizedBox(width: 2),
              Text(cat['lbl'] as String, style: AppEs.sm.copyWith(color: clr)),
              const SizedBox(width: 6),
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(color: prio['clr'] as Color, shape: BoxShape.circle),
              ),
            ]),
          ])),
          Icon(Icons.more_vert, size: 16, color: AppCSS.grs),
        ]),
      ),
    );
  }
}
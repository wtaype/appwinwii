import 'package:flutter/material.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../firebase.dart';

// 📋 COLECCIÓN: 'tareas' _______
const _col = 'tareas';

const _tipos = {
  'trabajo':  {'lbl': 'Trabajo',  'ico': Icons.work, 'clr': Color(0xFF29C72E)},
  'estudio':  {'lbl': 'Estudio',  'ico': Icons.book, 'clr': Color(0xFF7000FF)},
  'web':      {'lbl': 'Web',      'ico': Icons.language, 'clr': Color(0xFF0EBEFF)},
  'personal': {'lbl': 'Personal', 'ico': Icons.person, 'clr': Color(0xFFFFB800)},
  'otros':    {'lbl': 'Otros',    'ico': Icons.circle, 'clr': Color(0xFF94A3B8)},
};

const _estados = {
  'pendiente': {'lbl': 'Pendiente',   'ico': Icons.radio_button_unchecked, 'clr': Color(0xFFFFB800)},
  'progreso':  {'lbl': 'En progreso', 'ico': Icons.autorenew, 'clr': Color(0xFF0EBEFF)},
  'revision':  {'lbl': 'Revisión',    'ico': Icons.visibility, 'clr': Color(0xFF7000FF)},
  'hecho':     {'lbl': 'Hecho',       'ico': Icons.check_circle, 'clr': Color(0xFF29C72E)},
};

const _estNext = {'pendiente': 'progreso', 'progreso': 'revision', 'revision': 'hecho', 'hecho': 'hecho'};
const _estPrev = {'pendiente': 'pendiente', 'progreso': 'pendiente', 'revision': 'progreso', 'hecho': 'revision'};

const _prios = {
  'alta':  {'lbl': 'Alta',  'clr': Color(0xFFFF5C69)},
  'media': {'lbl': 'Media', 'clr': Color(0xFFFFB800)},
  'baja':  {'lbl': 'Baja',  'clr': Color(0xFF29C72E)},
};

const _prioSort = {'alta': 0, 'media': 1, 'baja': 2};

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  List<Map<String, dynamic>> items = [];
  bool load = true;
  String filtro = 'todas';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => load = true);
    try {
      items = await WiiDB.get(_col);
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  Future<void> _recargar() async {
    setState(() => load = true);
    try {
      items = await WiiDB.refresh(_col);
      if (mounted) Msg.ok(context, 'Tareas actualizadas 🔄');
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  List<Map<String, dynamic>> get _filtradas =>
      filtro == 'todas' ? items : items.where((t) => (t['estado'] ?? 'pendiente') == filtro).toList();

  int get _total => items.length;
  int get _done => items.where((t) => t['estado'] == 'hecho').length;
  int get _pct => _total > 0 ? (_done * 100 ~/ _total) : 0;
  int _countEst(String est) => items.where((t) => (t['estado'] ?? 'pendiente') == est).length;

  Future<void> _mover(Map<String, dynamic> item, String dir) async {
    final id = item['_id'] as String? ?? item['id'] as String? ?? '';
    if (id.isEmpty) return;
    final est = item['estado'] as String? ?? 'pendiente';
    final nuevo = dir == 'next' ? _estNext[est]! : _estPrev[est]!;
    if (nuevo == est) return;

    // Historial como en la web
    final hist = List<Map<String, dynamic>>.from(item['historial'] ?? []);
    hist.add({'de': est, 'a': nuevo, 'fecha': DateTime.now().toIso8601String()});

    setState(() {
      item['estado'] = nuevo;
      item['historial'] = hist;
    });

    try {
      final campos = <String, dynamic>{
        'estado': nuevo,
        'historial': hist,
      };
      if (nuevo == 'hecho') campos['completado'] = DateTime.now().toIso8601String();
      await WiiDB.update(_col, id, campos);

      if (mounted) {
        final emoji = {'pendiente': '⏳', 'progreso': '🔄', 'revision': '👀', 'hecho': '✅'}[nuevo] ?? '';
        Msg.ok(context, '$emoji → ${(_estados[nuevo]?['lbl']) ?? nuevo}');
      }
    } catch (e) {
      setState(() {
        item['estado'] = est;
        hist.removeLast();
      });
      if (mounted) Msg.er(context, 'Error: $e');
    }
  }

  Future<void> _toggleDone(Map<String, dynamic> item) async {
    final id = item['_id'] as String? ?? item['id'] as String? ?? '';
    if (id.isEmpty) return;
    final esHecho = item['estado'] == 'hecho';
    final nuevo = esHecho ? 'pendiente' : 'hecho';
    final estAnterior = item['estado'] as String? ?? 'pendiente';

    final hist = List<Map<String, dynamic>>.from(item['historial'] ?? []);
    hist.add({'de': estAnterior, 'a': nuevo, 'fecha': DateTime.now().toIso8601String()});

    setState(() {
      item['estado'] = nuevo;
      item['historial'] = hist;
    });

    try {
      final campos = <String, dynamic>{
        'estado': nuevo,
        'historial': hist,
      };
      if (nuevo == 'hecho') campos['completado'] = DateTime.now().toIso8601String();
      await WiiDB.update(_col, id, campos);
    } catch (e) {
      setState(() {
        item['estado'] = estAnterior;
        hist.removeLast();
      });
      if (mounted) Msg.er(context, 'Error: $e');
    }
  }

  Future<void> _eliminar(Map<String, dynamic> item) async {
    final id = item['_id'] as String? ?? item['id'] as String? ?? '';
    if (id.isEmpty) return;
    setState(() => items.remove(item));
    try {
      await WiiDB.del(_col, id);
      if (mounted) Msg.ok(context, 'Tarea eliminada ✅');
    } catch (e) {
      if (mounted) Msg.er(context, 'Error: $e');
      _cargar();
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (load) return const Load(msg: 'Cargando tareas...');

    return SafeArea(
      child: Column(children: [
        _toolbar(),
        _stats(),
        _filtros(),
        Expanded(child: _lista()),
      ]),
    );
  }

  Widget _toolbar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
    child: Glass(child: Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF5C69), Color(0xFFFFB800)]),
          borderRadius: BorderRadius.circular(AppCSS.rM),
        ),
        child: const Icon(Icons.check_circle, color: AppCSS.F, size: 22),
      ),
      AppCSS.ghm,
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Mis Tareas', style: AppEs.h3),
        Text('$_total tareas · $_done completadas', style: AppEs.sm),
      ])),
      IconButton(
        icon: const Icon(Icons.refresh, color: AppCSS.mco),
        onPressed: _recargar,
      ),
      IconButton(
        icon: const Icon(Icons.add, color: AppCSS.mco),
        onPressed: () {
          // TODO: Abrir modal nueva tarea
        },
      ),
    ])),
  );

  Widget _stats() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(children: _estados.entries.map((e) {
      final count = _countEst(e.key);
      final clr = e.value['clr'] as Color;
      final isLast = e.key == 'hecho';
      return Expanded(child: Container(
        margin: EdgeInsets.only(right: isLast ? 0 : 6),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: AppCSS.gCard,
        child: Column(children: [
          Icon(e.value['ico'] as IconData, size: 16, color: clr),
          const SizedBox(height: 2),
          Text('$count', style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
          Text(e.key == 'progreso' ? 'Prog.' : (e.key == 'revision' ? 'Rev.' : e.value['lbl'] as String),
            style: AppEs.sm.copyWith(fontSize: 10), overflow: TextOverflow.ellipsis,
          ),
        ]),
      ));
    }).toList()),
  );

  Widget _filtros() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    child: Row(children: [
      _filtroChip('todas', 'Todas', Icons.layers, AppCSS.mco, _total),
      ..._estados.entries.map((e) => _filtroChip(
        e.key,
        e.value['lbl'] as String,
        e.value['ico'] as IconData,
        e.value['clr'] as Color,
        _countEst(e.key),
      )),
    ]),
  );

  Widget _filtroChip(String key, String lbl, IconData ico, Color clr, int count) {
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
            color: sel ? clr : AppCSS.tx2,
            fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
          )),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: sel ? clr : AppCSS.grs.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$count', style: AppEs.sm.copyWith(
                color: sel ? AppCSS.F : AppCSS.tx3, fontSize: 10,
              )),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _lista() {
    final data = _filtradas;
    if (data.isEmpty) {
      return Vacio(
        msg: filtro == 'todas'
            ? 'Sin tareas\nAgrega tu primera tarea'
            : 'Sin tareas en\n${_estados[filtro]?['lbl'] ?? filtro}',
        ico: Icons.checklist,
        txtBtn: 'Nueva tarea',
        onTap: () {
          // TODO: Abrir modal nueva tarea
        },
      );
    }

    // Ordenar: prioridad > estado (igual que web)
    final sorted = List<Map<String, dynamic>>.from(data)..sort((a, b) {
      final pA = _prioSort[a['prio']] ?? 1;
      final pB = _prioSort[b['prio']] ?? 1;
      if (pA != pB) return pA.compareTo(pB);
      final estOrder = {'pendiente': 0, 'progreso': 1, 'revision': 2, 'hecho': 3};
      final eA = estOrder[a['estado']] ?? 0;
      final eB = estOrder[b['estado']] ?? 0;
      return eA.compareTo(eB);
    });

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: sorted.length,
      itemBuilder: (_, i) => _tareaCard(sorted[i]),
    );
  }

  Widget _tareaCard(Map<String, dynamic> t) {
    final tipo = _tipos[t['tipo']] ?? _tipos['otros']!;
    final est = _estados[t['estado']] ?? _estados['pendiente']!;
    final prio = _prios[t['prio']] ?? _prios['media']!;
    final clr = t['color'] != null
        ? Color(int.parse('0xFF${(t['color'] as String).replaceAll('#', '')}'))
        : tipo['clr'] as Color;
    final done = t['estado'] == 'hecho';
    final canPrev = t['estado'] != 'pendiente';
    final canNext = t['estado'] != 'hecho';

    // Subtareas
    final subs = (t['subtareas'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final subsDone = subs.where((s) => s['done'] == true).length;
    final subsPct = subs.isNotEmpty ? (subsDone / subs.length) : (done ? 1.0 : 0.0);

    return Dismissible(
      key: Key(t['_id'] ?? t['id'] ?? '${t.hashCode}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppCSS.err.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppCSS.rL),
        ),
        child: const Icon(Icons.delete, color: AppCSS.err),
      ),
      confirmDismiss: (_) async {
        final ok = await _confirmarEliminar(t);
        return ok;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppCSS.s),
        decoration: BoxDecoration(
          color: done ? AppCSS.F.withOpacity(0.5) : AppCSS.F.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppCSS.rL),
          border: Border.all(color: done ? AppCSS.brd.withOpacity(0.3) : clr.withOpacity(0.3)),
        ),
        child: Column(children: [
          // ── Body ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
            child: Row(children: [
              // Check
              GestureDetector(
                onTap: () => _toggleDone(t),
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? AppCSS.ok.withOpacity(0.15) : clr.withOpacity(0.1),
                    border: Border.all(color: done ? AppCSS.ok : clr, width: 2),
                  ),
                  child: done ? const Icon(Icons.check, size: 16, color: AppCSS.ok) : null,
                ),
              ),
              AppCSS.ghs,
              // Info
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['titulo'] ?? '', style: AppEs.bdS.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: done ? TextDecoration.lineThrough : null,
                  color: done ? AppCSS.grs : AppCSS.tx1,
                )),
                const SizedBox(height: 4),
                // Tags
                Wrap(spacing: 6, runSpacing: 4, children: [
                  _tag(tipo['ico'] as IconData, tipo['lbl'] as String, clr),
                  _tagDot(prio['lbl'] as String, prio['clr'] as Color),
                  if (t['fecha'] != null && (t['fecha'] as String).isNotEmpty)
                    _tagFecha(t['fecha']),
                ]),
                // Subtareas
                if (subs.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  ...subs.take(3).map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(children: [
                      Icon(
                        s['done'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 12,
                        color: s['done'] == true ? AppCSS.ok : AppCSS.grs,
                      ),
                      const SizedBox(width: 4),
                      Expanded(child: Text(
                        s['txt'] ?? '',
                        style: AppEs.sm.copyWith(
                          decoration: s['done'] == true ? TextDecoration.lineThrough : null,
                          color: s['done'] == true ? AppCSS.grs : AppCSS.tx2,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      )),
                    ]),
                  )),
                  if (subs.length > 3)
                    Text('+${subs.length - 3} más', style: AppEs.sm.copyWith(color: AppCSS.tx3)),
                  const SizedBox(height: 4),
                  // Barra progreso
                  Row(children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: subsPct,
                        minHeight: 4,
                        backgroundColor: AppCSS.brd.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(clr),
                      ),
                    )),
                    const SizedBox(width: 6),
                    Text('$subsDone/${subs.length}', style: AppEs.sm.copyWith(fontSize: 10)),
                  ]),
                ],
              ])),
              // Menu eliminar
              IconButton(
                icon: const Icon(Icons.more_vert, size: 18, color: AppCSS.grs),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () async {
                  final ok = await _confirmarEliminar(t);
                  if (ok == true) _eliminar(t);
                },
              ),
            ]),
          ),
          // ── Flow: ← Estado → ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppCSS.brd.withOpacity(0.3))),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: canPrev ? () => _mover(t, 'prev') : null,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: canPrev ? AppCSS.mco.withOpacity(0.1) : AppCSS.O,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.chevron_left, size: 20,
                    color: canPrev ? AppCSS.mco : AppCSS.brd,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (est['clr'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppCSS.rS),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(est['ico'] as IconData, size: 14, color: est['clr'] as Color),
                  const SizedBox(width: 4),
                  Text(est['lbl'] as String, style: AppEs.sm.copyWith(
                    color: est['clr'] as Color,
                    fontWeight: FontWeight.w600,
                  )),
                ]),
              ),
              const Spacer(),
              GestureDetector(
                onTap: canNext ? () => _mover(t, 'next') : null,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: canNext ? AppCSS.mco.withOpacity(0.1) : AppCSS.O,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.chevron_right, size: 20,
                    color: canNext ? AppCSS.mco : AppCSS.brd,
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _tag(IconData ico, String lbl, Color clr) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: clr.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(ico, size: 10, color: clr),
      const SizedBox(width: 3),
      Text(lbl, style: AppEs.sm.copyWith(color: clr)),
    ]),
  );

  Widget _tagDot(String lbl, Color clr) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(color: clr, shape: BoxShape.circle)),
    const SizedBox(width: 3),
    Text(lbl, style: AppEs.sm),
  ]);

  Widget _tagFecha(String f) {
    final hoy = DateTime.now();
    final hoyStr = '${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
    final diff = DateTime.tryParse(f)?.difference(DateTime.parse(hoyStr)).inDays;
    final vencido = diff != null && diff < 0;
    final esHoy = diff == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: vencido ? AppCSS.err.withOpacity(0.1) : (esHoy ? AppCSS.mco.withOpacity(0.1) : AppCSS.grs.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.schedule, size: 10,
          color: vencido ? AppCSS.err : (esHoy ? AppCSS.mco : AppCSS.tx3)),
        const SizedBox(width: 2),
        Text(
          esHoy ? 'Hoy' : (vencido ? 'Vencido ${-diff!}d' : _fmtFecha(f)),
          style: AppEs.sm.copyWith(
            color: vencido ? AppCSS.err : (esHoy ? AppCSS.mco : AppCSS.tx3),
            fontWeight: (vencido || esHoy) ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ]),
    );
  }

  Future<bool?> _confirmarEliminar(Map<String, dynamic> t) => showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Eliminar tarea', style: AppEs.h3),
      content: Text('¿Eliminar "${t['titulo']}"?', style: AppEs.bd),
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
          child: Text('Eliminar', style: AppEs.bdS.copyWith(color: AppCSS.F)),
        ),
      ],
    ),
  );

  String _fmtFecha(String f) {
    try {
      final d = DateTime.parse(f);
      const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
      return '${d.day} ${meses[d.month - 1]}';
    } catch (_) { return f; }
  }
}
import 'package:flutter/material.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../firebase.dart';

// 📆 COLECCIÓN _______
const _col = 'meses';

const _mesesEs = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
const _diasEs = ['Dom','Lun','Mar','Mié','Jue','Vie','Sáb'];

const _catMes = {
  'trabajo':   {'lbl': 'Trabajo',  'ico': Icons.work, 'clr': Color(0xFF0EBEFF)},
  'personal':  {'lbl': 'Personal', 'ico': Icons.person, 'clr': Color(0xFFFFB800)},
  'estudio':   {'lbl': 'Estudio',  'ico': Icons.book, 'clr': Color(0xFF7000FF)},
  'salud':     {'lbl': 'Salud',    'ico': Icons.favorite, 'clr': Color(0xFFFF5C69)},
  'finanzas':  {'lbl': 'Finanzas', 'ico': Icons.monetization_on, 'clr': Color(0xFF29C72E)},
  'reunion':   {'lbl': 'Reunión',  'ico': Icons.groups, 'clr': Color(0xFFA855F7)},
  'proyecto':  {'lbl': 'Proyecto', 'ico': Icons.account_tree, 'clr': Color(0xFF00C9B1)},
  'otro':      {'lbl': 'Otro',     'ico': Icons.circle, 'clr': Color(0xFF94A3B8)},
};

const _prioMes = {
  'alta':  {'lbl': 'Alta',  'clr': Color(0xFFFF5C69), 'ico': Icons.arrow_upward},
  'media': {'lbl': 'Media', 'clr': Color(0xFFFFB800), 'ico': Icons.remove},
  'baja':  {'lbl': 'Baja',  'clr': Color(0xFF29C72E), 'ico': Icons.arrow_downward},
};

class VistaMes extends StatefulWidget {
  const VistaMes({super.key});

  @override
  State<VistaMes> createState() => _VistaMesState();
}

class _VistaMesState extends State<VistaMes> {
  late int anio;
  late int mes;
  String? selFecha;
  List<Map<String, dynamic>> items = [];
  bool load = true;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    anio = n.year;
    mes = n.month;
    selFecha = _fmtISO(n);
    _cargar();
  }

  String _fmtISO(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String get _hoy => _fmtISO(DateTime.now());
  int get _diasEnMes => DateTime(anio, mes + 1, 0).day;
  int get _primerDow => DateTime(anio, mes, 1).weekday % 7; // 0=Dom

  String _fechaStr(int d) =>
      '$anio-${mes.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';

  String get _desde => '$anio-${mes.toString().padLeft(2, '0')}-01';
  String get _hasta => '$anio-${mes.toString().padLeft(2, '0')}-${_diasEnMes.toString().padLeft(2, '0')}';

  List<Map<String, dynamic>> _diaItems(String f) =>
      items.where((x) => x['fecha'] == f).toList();

  int get _total => items.length;
  int get _done => items.where((x) => x['done'] == true).length;
  int get _alta => items.where((x) => x['prioridad'] == 'alta').length;

  Future<void> _cargar() async {
    setState(() => load = true);
    try {
      items = await WiiDB.getR(_col, 'fecha', _desde, _hasta);
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  Future<void> _recargar() async {
    setState(() => load = true);
    try {
      items = await WiiDB.refreshR(_col, 'fecha', _desde, _hasta);
      if (mounted) Notificacion.ok(context, 'Mes actualizado 🔄');
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
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
    setState(() => items.remove(item));
    try {
      await WiiDB.del(_col, id);
      if (mounted) Notificacion.ok(context, 'Eliminado ✅');
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
      _cargar();
    }
  }

  void _cambiarMes(int dir) {
    setState(() {
      if (dir > 0) {
        if (mes == 12) { mes = 1; anio++; } else { mes++; }
      } else {
        if (mes == 1) { mes = 12; anio--; } else { mes--; }
      }
    });
    _cargar();
  }

  @override
  Widget build(BuildContext ctx) {
    if (load) return const Load(msg: 'Cargando mes...');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _toolbar(),
        AppCSS.gs,
        _stats(),
        AppCSS.gm,
        _grid(),
        AppCSS.gm,
        _detalle(),
      ]),
    );
  }

  Widget _toolbar() => Glass(child: Row(children: [
    IconButton(
      icon: const Icon(Icons.chevron_left, color: AppCSS.mco),
      onPressed: () => _cambiarMes(-1),
    ),
    Expanded(child: Text(
      '${_mesesEs[mes - 1]} $anio',
      style: AppEs.h3.copyWith(color: AppCSS.mco),
      textAlign: TextAlign.center,
    )),
    TextButton.icon(
      onPressed: () {
        final n = DateTime.now();
        setState(() { anio = n.year; mes = n.month; selFecha = _hoy; });
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
      onPressed: () => _cambiarMes(1),
    ),
  ]));

  Widget _stats() => Row(children: [
    wiStat('$_total', 'Eventos', Icons.layers, AppCSS.mco),
    AppCSS.ghs,
    wiStat('$_done', 'Hechos', Icons.check_circle, AppCSS.bg2),
    AppCSS.ghs,
    wiStat('$_alta', 'Urgentes', Icons.local_fire_department, AppCSS.bg4),
  ]);

  Widget _grid() => Container(
    padding: const EdgeInsets.all(10),
    decoration: AppCSS.gls2,
    child: Column(children: [
      Row(children: _diasEs.map((d) => Expanded(
        child: Center(child: Text(d, style: AppEs.sm.copyWith(
          fontWeight: FontWeight.w600,
          color: (d == 'Dom' || d == 'Sáb') ? AppCSS.bg4 : AppCSS.tx2,
        ))),
      )).toList()),
      const SizedBox(height: 6),
      ..._buildRows(),
    ]),
  );

  List<Widget> _buildRows() {
    final rows = <Widget>[];
    final cells = <Widget>[];

    for (var i = 0; i < _primerDow; i++) {
      cells.add(const Expanded(child: SizedBox(height: 44)));
    }

    for (var d = 1; d <= _diasEnMes; d++) {
      final f = _fechaStr(d);
      final esH = f == _hoy;
      final esS = f == selFecha;
      final dI = _diaItems(f);

      cells.add(Expanded(
        child: GestureDetector(
          onTap: () => setState(() => selFecha = f),
          child: Container(
            height: 44,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: esS ? AppCSS.mco.withOpacity(0.15) : (esH ? AppCSS.mco.withOpacity(0.08) : null),
              borderRadius: BorderRadius.circular(AppCSS.rS),
              border: esH ? Border.all(color: AppCSS.mco, width: 1.5) : null,
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('$d', style: AppEs.bdS.copyWith(
                fontWeight: esH ? FontWeight.w700 : FontWeight.w500,
                color: esH ? AppCSS.mco : (f.compareTo(_hoy) < 0 ? AppCSS.grs : AppCSS.tx1),
              )),
              if (dI.isNotEmpty)
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: dI.take(3).map((item) {
                    final cat = _catMes[item['categoria']] ?? _catMes['otro']!;
                    final clr = cat['clr'] as Color;
                    return Container(
                      width: 5, height: 5, margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(color: clr, shape: BoxShape.circle),
                    );
                  }).toList(),
                ),
            ]),
          ),
        ),
      ));

      if (cells.length == 7) {
        rows.add(Row(children: List.from(cells)));
        cells.clear();
      }
    }

    while (cells.length < 7 && cells.isNotEmpty) {
      cells.add(const Expanded(child: SizedBox(height: 44)));
    }
    if (cells.isNotEmpty) rows.add(Row(children: List.from(cells)));

    return rows;
  }

  Widget _detalle() {
    if (selFecha == null) return const SizedBox.shrink();

    final dI = _diaItems(selFecha!);
    final d = DateTime.parse(selFecha!);
    final esH = selFecha == _hoy;
    final past = selFecha!.compareTo(_hoy) < 0;

    return Container(
      decoration: AppCSS.gls2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppCSS.brd.withOpacity(0.3))),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: esH ? AppCSS.mco : (past ? AppCSS.grs.withOpacity(0.2) : AppCSS.brd.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(AppCSS.rS),
              ),
              child: Icon(Icons.calendar_today, size: 18, color: esH ? AppCSS.whi : AppCSS.grs),
            ),
            AppCSS.ghs,
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${_diasEs[d.weekday % 7]}${esH ? ' · Hoy' : ''}',
                style: AppEs.bdS.copyWith(fontWeight: FontWeight.w600),
              ),
              Text('${d.day} ${_mesesEs[d.month - 1]} ${d.year}', style: AppEs.sm),
            ])),
            if (!past) IconButton(
              icon: const Icon(Icons.add, color: AppCSS.mco, size: 20),
              onPressed: () {
                // TODO: Abrir modal nuevo evento para selFecha
              },
            ),
          ]),
        ),
        if (dI.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Column(children: [
              Icon(Icons.event_busy, size: 40, color: AppCSS.brd),
              AppCSS.gs,
              Text(past ? 'Sin eventos registrados' : 'Día libre — agrega un evento', style: AppEs.sm),
            ])),
          )
        else
          ...dI.map((item) => _eventoItem(item)),
        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _eventoItem(Map<String, dynamic> item) {
    final cat = _catMes[item['categoria']] ?? _catMes['otro']!;
    final prio = _prioMes[item['prioridad']] ?? _prioMes['media']!;
    final clr = cat['clr'] as Color;
    final done = item['done'] == true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: clr, width: 3)),
      ),
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
            Icon(prio['ico'] as IconData, size: 11, color: prio['clr'] as Color),
          ]),
          if (item['nota'] != null && (item['nota'] as String).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(item['nota'], style: AppEs.sm, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
        ])),
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 16, color: AppCSS.grs),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () {
              // TODO: Editar evento
            },
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: AppCSS.bg4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () async {
              final ok = await Mensaje(context, msg: '¿Eliminar "${item['titulo']}"?');
              if (ok == true) _eliminar(item);
            },
          ),
        ]),
      ]),
    );
  }

}
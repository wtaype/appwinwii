import 'package:flutter/material.dart';
import '../../wicss.dart';
import '../../widev.dart';
import '../firebase.dart';
import 'semanal.dart';
import 'mes.dart';

// 📅 COLECCIÓN _______
const _col = 'horario';

// 📅 PANTALLA HORARIO (con sub-tabs) _______
class PantallaHorario extends StatefulWidget {
  const PantallaHorario({super.key});

  @override
  State<PantallaHorario> createState() => _PantallaHorarioState();
}

class _PantallaHorarioState extends State<PantallaHorario> with SingleTickerProviderStateMixin {
  late final TabController tabC;

  static const _tabs = [
    {'ico': Icons.calendar_today, 'txt': 'Horario', 'clr': AppCSS.bg1},
    {'ico': Icons.view_week, 'txt': 'Semanal', 'clr': AppCSS.bg3},
    {'ico': Icons.calendar_view_month, 'txt': 'Mes', 'clr': AppCSS.bg5},
  ];

  @override
  void initState() {
    super.initState();
    tabC = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext ctx) => SafeArea(
    child: Column(children: [
      // 🔝 Tab bar _______
      Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppCSS.whi.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppCSS.rM),
          border: Border.all(color: AppCSS.brd.withOpacity(0.5)),
        ),
        child: TabBar(
          controller: tabC,
          indicator: BoxDecoration(
            gradient: AppCSS.gSky,
            borderRadius: BorderRadius.circular(AppCSS.rS),
          ),
          labelColor: AppCSS.whi,
          unselectedLabelColor: AppCSS.tx2,
          labelStyle: AppEs.bdS.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppEs.bdS,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: AppCSS.O,
          tabs: _tabs.map((t) => Tab(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(t['ico'] as IconData, size: 16),
              const SizedBox(width: 6),
              Text(t['txt'] as String),
            ]),
          )).toList(),
        ),
      ),
      // 📄 Contenido _______
      Expanded(
        child: TabBarView(
          controller: tabC,
          children: const [
            _VistaHorario(),
            VistaSemanal(),
            VistaMes(),
          ],
        ),
      ),
    ]),
  );

  @override
  void dispose() {
    tabC.dispose();
    super.dispose();
  }
}

// 📅 TIPOS HORARIO (mismos que horario.js) _______
const _tipos = {
  'trabajo':  {'lbl': 'Trabajo',  'ico': Icons.work, 'clr': Color(0xFF0EBEFF)},
  'personal': {'lbl': 'Personal', 'ico': Icons.person, 'clr': Color(0xFF29C72E)},
  'estudio':  {'lbl': 'Estudio',  'ico': Icons.book, 'clr': Color(0xFF7000FF)},
  'urgente':  {'lbl': 'Urgente',  'ico': Icons.local_fire_department, 'clr': Color(0xFFFF5C69)},
  'reunion':  {'lbl': 'Reunión',  'ico': Icons.groups, 'clr': Color(0xFFFFB800)},
  'sueno':    {'lbl': 'Sueño',    'ico': Icons.nightlight, 'clr': Color(0xFF3D4C7E)},
  'otro':     {'lbl': 'Otro',     'ico': Icons.circle, 'clr': Color(0xFF94A3B8)},
};

const _repetir = {
  'solo_hoy': 'Solo hoy',
  'lun_vie':  'Lunes a Viernes',
  'lun_sab':  'Lunes a Sábado',
  'todos':    'Todos los días',
  'rango':    'Fecha específica',
};

// Mapeo repetir → días de semana (1=Lun, 7=Dom)
const _repDias = {
  'solo_hoy': <int>[],
  'lun_vie':  [1, 2, 3, 4, 5],
  'lun_sab':  [1, 2, 3, 4, 5, 6],
  'todos':    [1, 2, 3, 4, 5, 6, 7],
  'rango':    <int>[],
};

// 📅 VISTA HORARIO _______
class _VistaHorario extends StatefulWidget {
  const _VistaHorario();

  @override
  State<_VistaHorario> createState() => _VistaHorarioState();
}

class _VistaHorarioState extends State<_VistaHorario> {
  DateTime selDia = DateTime.now();
  List<Map<String, dynamic>> _todos = []; // Todos los eventos del usuario
  List<Map<String, dynamic>> eventos = []; // Filtrados para el día
  bool load = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => load = true);
    try {
      _todos = await WiiDB.get(_col);
      _filtrarDia();
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  Future<void> _recargar() async {
    setState(() => load = true);
    try {
      _todos = await WiiDB.refresh(_col);
      _filtrarDia();
    } catch (e) {
      if (mounted) Notificacion.err(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => load = false);
    }
  }

  /// Filtrar eventos para selDia considerando repetición
  void _filtrarDia() {
    final f = _fechaStr;
    final dow = selDia.weekday; // 1=Lun, 7=Dom
    final result = <Map<String, dynamic>>[];

    for (final ev in _todos) {
      final rep = ev['repetir'] as String? ?? 'solo_hoy';
      final fechaEv = ev['fecha'] as String? ?? '';
      final fechaIni = ev['fechaInicio'] as String? ?? fechaEv;
      final fechaFin = ev['fechaFin'] as String? ?? fechaEv;

      bool mostrar = false;

      if (rep == 'solo_hoy') {
        // Solo coincide si la fecha es exacta
        mostrar = fechaEv == f;
      } else if (rep == 'rango') {
        // Mostrar si estamos dentro del rango de fechas
        mostrar = f.compareTo(fechaIni) >= 0 && f.compareTo(fechaFin) <= 0;
      } else {
        // Repetición por días de la semana
        final dias = _repDias[rep] ?? [];
        if (dias.contains(dow)) {
          // Verificar que estamos dentro del rango de fechas del evento
          if (fechaIni.isNotEmpty && fechaFin.isNotEmpty) {
            mostrar = f.compareTo(fechaIni) >= 0 && f.compareTo(fechaFin) <= 0;
          } else if (fechaEv.isNotEmpty) {
            mostrar = f.compareTo(fechaEv) >= 0;
          } else {
            mostrar = dias.contains(dow);
          }
        }
      }

      if (mostrar) result.add(ev);
    }

    // Ordenar por horaInicio
    result.sort((a, b) {
      final ha = a['horaInicio'] as String? ?? '99:99';
      final hb = b['horaInicio'] as String? ?? '99:99';
      return ha.compareTo(hb);
    });

    eventos = result;
  }

  String get _fechaStr =>
      '${selDia.year}-${selDia.month.toString().padLeft(2, '0')}-${selDia.day.toString().padLeft(2, '0')}';

  bool get _esHoy {
    final h = DateTime.now();
    return selDia.year == h.year && selDia.month == h.month && selDia.day == h.day;
  }

  String get _diaStr {
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return dias[selDia.weekday - 1];
  }

  int get _minTotales {
    int min = 0;
    for (final ev in eventos) {
      final hi = ev['horaInicio'] as String? ?? '';
      final hf = ev['horaFin'] as String? ?? '';
      if (hi.contains(':') && hf.contains(':')) {
        final pi = hi.split(':'); final pf = hf.split(':');
        final mi = int.tryParse(pi[0])! * 60 + int.tryParse(pi[1])!;
        final mf = int.tryParse(pf[0])! * 60 + int.tryParse(pf[1])!;
        if (mf > mi) min += mf - mi;
      }
    }
    return min;
  }

  String get _horasStr {
    final m = _minTotales;
    if (m == 0) return '0h';
    final h = m ~/ 60;
    final r = m % 60;
    return r > 0 ? '${h}h ${r}m' : '${h}h';
  }

  int get _doneCount => eventos.where((e) => e['completado'] == true).length;
  int get _pct => eventos.isNotEmpty ? (_doneCount * 100 ~/ eventos.length) : 0;

  Future<void> _toggleComp(Map<String, dynamic> ev) async {
    final id = ev['_id'] as String? ?? ev['id'] as String? ?? '';
    if (id.isEmpty) return;
    final nuevo = !(ev['completado'] == true);
    setState(() => ev['completado'] = nuevo);
    try {
      await WiiDB.toggle(_col, id, 'completado', nuevo);
    } catch (e) {
      setState(() => ev['completado'] = !nuevo);
      if (mounted) Notificacion.err(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (load) return const Load(msg: 'Cargando horario...');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppCSS.pL,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _cabecera(),
        AppCSS.gm,
        _acciones(),
        AppCSS.gm,
        _listaEventos(),
        AppCSS.gm,
        _resumen(),
      ]),
    );
  }

  Widget _cabecera() => Glass(child: Row(children: [
    Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: _esHoy ? AppCSS.gSky : null,
        color: _esHoy ? null : AppCSS.grs.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppCSS.rM),
      ),
      child: Icon(Icons.calendar_today, color: _esHoy ? AppCSS.whi : AppCSS.grs, size: 22),
    ),
    AppCSS.ghm,
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_esHoy ? 'Hoy · $_diaStr' : _diaStr, style: AppEs.h3),
      Text(_fechaStr, style: AppEs.lbl),
    ])),
    Row(children: [
      _navBtn(Icons.chevron_left, () {
        setState(() { selDia = selDia.subtract(const Duration(days: 1)); _filtrarDia(); });
      }),
      if (!_esHoy) _navBtn(Icons.my_location, () {
        setState(() { selDia = DateTime.now(); _filtrarDia(); });
      }),
      _navBtn(Icons.chevron_right, () {
        setState(() { selDia = selDia.add(const Duration(days: 1)); _filtrarDia(); });
      }),
    ]),
  ]));

  Widget _navBtn(IconData ico, VoidCallback fn) => IconButton(
    onPressed: fn, icon: Icon(ico, size: 20, color: AppCSS.mco),
    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
  );

  Widget _acciones() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      const Icon(Icons.bolt, size: 16, color: AppCSS.mco),
      const SizedBox(width: 4),
      Text('Acciones rápidas', style: AppEs.lbl),
    ]),
    AppCSS.gs,
    Wrap(spacing: 8, runSpacing: 8, children: [
      _accion('Hoy', Icons.my_location, const Color(0xFFFF5C69), () {
        setState(() { selDia = DateTime.now(); _filtrarDia(); });
      }),
      _accion('Sync', Icons.refresh, const Color(0xFF0EBEFF), _recargar),
    ]),
  ]);

  Widget _accion(String txt, IconData ico, Color clr, VoidCallback fn) => GestureDetector(
    onTap: fn,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: clr.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppCSS.rS),
        border: Border.all(color: clr.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(ico, size: 14, color: clr),
        const SizedBox(width: 4),
        Text(txt, style: AppEs.sm.copyWith(color: clr, fontWeight: FontWeight.w600)),
      ]),
    ),
  );

  Widget _listaEventos() {
    if (eventos.isEmpty) {
      return const Vacio(msg: 'Sin eventos\npara este día', ico: Icons.event_busy);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.timeline, size: 16, color: AppCSS.mco),
        const SizedBox(width: 4),
        Text('Timeline · ${eventos.length} eventos', style: AppEs.lbl),
      ]),
      AppCSS.gs,
      ...eventos.map((ev) => _eventoCard(ev)),
    ]);
  }

  Widget _eventoCard(Map<String, dynamic> ev) {
    final tipo = _tipos[ev['tipo']] ?? _tipos['otro']!;
    final clr = wicoHx(ev['color'] as String?, tipo['clr'] as Color);
    final done = ev['completado'] == true;
    final hi = ev['horaInicio'] as String? ?? '';
    final hf = ev['horaFin'] as String? ?? '';
    final rep = ev['repetir'] as String? ?? 'solo_hoy';
    final esSueno = ev['sueno'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppCSS.s),
      child: GestureDetector(
        onTap: () => _toggleComp(ev),
        child: Container(
          decoration: BoxDecoration(
            color: done ? AppCSS.whi.withOpacity(0.5) : AppCSS.whi.withOpacity(0.7),
            borderRadius: BorderRadius.circular(AppCSS.rL),
            border: Border.all(color: done ? AppCSS.brd.withOpacity(0.3) : clr.withOpacity(0.3)),
          ),
          child: Row(children: [
            // Barra lateral color
            Container(
              width: 4, height: 72,
              decoration: BoxDecoration(
                color: done ? AppCSS.ok : clr,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            AppCSS.ghs,
            // Icono tipo
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (done ? AppCSS.ok : clr).withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppCSS.rS),
              ),
              child: Icon(
                done ? Icons.check_circle : (esSueno ? Icons.nightlight : tipo['ico'] as IconData),
                size: 18, color: done ? AppCSS.ok : clr,
              ),
            ),
            AppCSS.ghs,
            // Info
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ev['titulo'] ?? '', style: AppEs.bdS.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: done ? TextDecoration.lineThrough : null,
                  color: done ? AppCSS.grs : AppCSS.tx1,
                )),
                const SizedBox(height: 2),
                Row(children: [
                  if (hi.isNotEmpty) ...[
                    Icon(Icons.schedule, size: 12, color: AppCSS.tx3),
                    const SizedBox(width: 2),
                    Text(hf.isNotEmpty ? '$hi → $hf' : hi, style: AppEs.sm),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: clr.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(tipo['lbl'] as String, style: AppEs.sm.copyWith(color: clr, fontSize: 10)),
                  ),
                  if (rep != 'solo_hoy') ...[
                    const SizedBox(width: 4),
                    Icon(Icons.repeat, size: 10, color: AppCSS.tx3),
                    const SizedBox(width: 2),
                    Text(_repetir[rep] ?? rep, style: AppEs.sm.copyWith(fontSize: 10)),
                  ],
                  if (esSueno && ev['suenoHoras'] != null && ev['suenoHoras'] > 0) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.bedtime, size: 10, color: const Color(0xFF3D4C7E)),
                    const SizedBox(width: 2),
                    Text('${ev['suenoHoras']}h', style: AppEs.sm.copyWith(fontSize: 10)),
                  ],
                ]),
                // Subtareas
                if (ev['subtareas'] != null && (ev['subtareas'] as List).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _subtareas(ev['subtareas'] as List),
                ],
              ]),
            )),
            // Check
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                done ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 20, color: done ? AppCSS.ok : AppCSS.brd,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _subtareas(List subs) {
    final total = subs.length;
    final done = subs.where((s) => s is Map && s['done'] == true).length;
    return Row(children: [
      Icon(Icons.checklist, size: 11, color: AppCSS.tx3),
      const SizedBox(width: 3),
      Text('$done/$total subtareas', style: AppEs.sm.copyWith(fontSize: 10)),
      const SizedBox(width: 4),
      Expanded(child: wiProgress(total > 0 ? done / total : 0, AppCSS.ok, h: 3)),
    ]);
  }

  Widget _resumen() => Glass(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    _resStat('${eventos.length}', 'Eventos', Icons.event, AppCSS.mco),
    _resStat(_horasStr, 'Horas', Icons.schedule, AppCSS.bg1),
    _resStat('$_pct%', 'Hecho', Icons.check_circle, AppCSS.bg2),
  ]));

  Widget _resStat(String val, String lbl, IconData ico, Color clr) => Column(children: [
    Icon(ico, size: 20, color: clr),
    const SizedBox(height: 4),
    Text(val, style: AppEs.bdS.copyWith(color: clr, fontWeight: FontWeight.w700)),
    Text(lbl, style: AppEs.sm),
  ]);
}
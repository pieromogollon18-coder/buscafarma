import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ============================================================
//  BuscaFarma - app de demostración (sin paquetes externos)
//  Reemplaza todo el contenido de lib/main.dart con este archivo
// ============================================================

const kGreen = Color(0xFF136F5C);
const kDark = Color(0xFF123D33);
const kBg = Color(0xFFF6F8F7);
const kMint = Color(0xFFDCF1EA);
const kOrange = Color(0xFFF08A4B);
const kOrangeText = Color(0xFFC96A2B);
const kOrangeBg = Color(0xFFFDEBDD);
const kRed = Color(0xFFD64545);
const kRedBg = Color(0xFFFBE3E3);
const kGrey = Color(0xFF6B7773);

void main() => runApp(const MyApp());

// ---------------- MODELOS Y ESTADO ----------------

class Med {
  final String name, active, pres;
  final double price;
  final bool generic;
  const Med(this.name, this.active, this.pres, this.price,
      {this.generic = false});
}

const meds = [
  Med('Panadol Forte', 'Paracetamol 500 mg', 'Caja x 20 tabletas', 12.90),
  Med('Paracetamol Genfar', 'Paracetamol 500 mg', 'Caja x 20 tabletas', 7.90,
      generic: true),
  Med('Ibuprofeno 400 mg', 'Ibuprofeno 400 mg', 'Caja x 10 tabletas', 9.50),
  Med('Amoxicilina 500 mg', 'Amoxicilina 500 mg', 'Caja x 12 cápsulas', 15.00),
];

class Sede {
  final String name, address, hours, phone;
  final double extra;
  final int units;
  const Sede(this.name, this.address, this.hours, this.phone, this.extra,
      this.units);
}

const sedes = [
  Sede('Boticas Salud Larco', 'Av. Larco 742, Miraflores',
      'Lun–Dom · 7:00 a. m.–10:00 p. m.', '(01) 445-2080', 0, 8),
  Sede('Farmacia Central Kennedy', 'Av. Kennedy 120, Miraflores',
      'Lun–Sáb · 8:00 a. m.–9:00 p. m.', '(01) 445-1100', 0.60, 3),
];

class Reserva {
  final String code;
  final Med med;
  final Sede sede;
  final int qty;
  final String status;
  Reserva(this.code, this.med, this.sede, this.qty, this.status);
  double get total => (med.price + sede.extra) * qty;
}

class AppState {
  static bool logged = false;
  static String name = 'Mariana';
  static final tab = ValueNotifier<int>(0);
  static final reservas = <Reserva>[
    Reserva('BC-4827', meds[0], sedes[0], 2, 'Lista para retiro'),
    Reserva('BC-4811', meds[0], sedes[0], 2, 'Reservada'),
    Reserva('BC-4790', meds[0], sedes[0], 2, 'Pagada'),
    Reserva('BC-4702', meds[0], sedes[0], 2, 'Entregada'),
    Reserva('BC-4650', meds[0], sedes[0], 2, 'Cancelada'),
    Reserva('BC-4599', meds[0], sedes[0], 2, 'Expirada'),
  ];
}

String money(double v) => 'S/ ${v.toStringAsFixed(2)}';

void push(BuildContext c, Widget w) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => w));

void toHome(BuildContext c, {int tab = 0}) {
  AppState.tab.value = tab;
  Navigator.pushAndRemoveUntil(
      c, MaterialPageRoute(builder: (_) => const HomeShell()), (r) => false);
}

// ---------------- APP ----------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuscaFarma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: kGreen,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Color(0xFF1B2B26), fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------- WIDGETS REUTILIZABLES ----------------

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool outline;
  final Color color;
  const Btn(this.text, this.onTap,
      {super.key, this.outline = false, this.color = kGreen});
  @override
  Widget build(BuildContext context) {
    final shape = const StadiumBorder();
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: outline
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                  shape: shape,
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1B2B26),
                  side: const BorderSide(color: Color(0xFFE0E6E3))),
              child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)))
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                  shape: shape,
                  elevation: 0,
                  backgroundColor: color,
                  foregroundColor: Colors.white),
              child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600))),
    );
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const Box(this.child,
      {super.key,
      this.color = Colors.white,
      this.padding = const EdgeInsets.all(14),
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const Pill(this.text, {super.key, this.bg = kMint, this.fg = kGreen});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}

class CountdownText extends StatefulWidget {
  final int seconds;
  final TextStyle? style;
  final bool hours;
  const CountdownText(this.seconds, {super.key, this.style, this.hours = false});
  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late int left = widget.seconds;
  Timer? t;
  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (left > 0 && mounted) setState(() => left--);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = (left ~/ 60).toString().padLeft(2, '0');
    final s = (left % 60).toString().padLeft(2, '0');
    return Text('$m:$s', style: widget.style);
  }
}

class TimerBanner extends StatelessWidget {
  final String text;
  final int seconds;
  const TimerBanner(this.text, this.seconds, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: kOrangeBg, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.timer_outlined, color: kOrangeText, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(color: kOrangeText, fontSize: 12))),
          CountdownText(seconds,
              style: const TextStyle(
                  color: kOrangeText, fontWeight: FontWeight.w600)),
        ]),
      );
}

class MedIcon extends StatelessWidget {
  final bool generic;
  final double size;
  const MedIcon({super.key, this.generic = false, this.size = 48});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: generic ? kMint : kOrangeBg,
            borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.medication_outlined,
            color: generic ? kGreen : kOrange, size: size * .5),
      );
}

class MedTile extends StatelessWidget {
  final Med m;
  const MedTile(this.m, {super.key});
  @override
  Widget build(BuildContext context) => Box(
        onTap: () => push(context, DetailScreen(m)),
        Row(children: [
          MedIcon(generic: m.generic),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${m.active} · ${m.pres}',
                style: const TextStyle(fontSize: 11, color: kGrey)),
            Text(m.generic ? money(m.price) : 'Desde ${money(m.price)}',
                style: const TextStyle(
                    color: kGreen, fontWeight: FontWeight.w600, fontSize: 13)),
          ])),
          const Icon(Icons.chevron_right, color: kGrey),
        ]),
      );
}

Widget textField(String label, IconData icon, String hint, TextEditingController c,
    {bool obscure = false, TextInputType? type}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      TextField(
        controller: c,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: kGrey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E6E3))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E6E3))),
        ),
      ),
    ]),
  );
}

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 36});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: kGreen, borderRadius: BorderRadius.circular(size * .28)),
        child: Icon(Icons.favorite_border, color: Colors.white, size: size * .6),
      );
}

// ---------- Mapa falso dibujado (no necesita Google Maps) ----------

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFDDEBD9));
    c.drawRect(Rect.fromLTWH(0, 0, s.width * .18, s.height),
        Paint()..color = const Color(0xFFBFDDEB));
    final r = Random(7);
    final line = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 9; i++) {
      c.drawLine(Offset(s.width * .2 + r.nextDouble() * s.width * .8, 0),
          Offset(s.width * .2 + r.nextDouble() * s.width * .8, s.height), line);
      c.drawLine(Offset(s.width * .18, r.nextDouble() * s.height),
          Offset(s.width, r.nextDouble() * s.height), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class FakeMap extends StatelessWidget {
  final double height;
  const FakeMap({super.key, this.height = 200});
  Widget pin() => Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle),
        child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 16),
      );
  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(children: [
          Positioned.fill(child: CustomPaint(painter: MapPainter())),
          Align(alignment: const Alignment(-.55, -.4), child: pin()),
          Align(alignment: const Alignment(.1, -.2), child: pin()),
          Align(alignment: const Alignment(.65, .35), child: pin()),
        ]),
      );
}

// ---------- QR falso ----------

class QrPainter extends CustomPainter {
  final String code;
  QrPainter(this.code);
  @override
  void paint(Canvas c, Size s) {
    const n = 21;
    final cell = s.width / n;
    final p = Paint()..color = kDark;
    final r = Random(code.hashCode);
    bool finder(int x, int y) =>
        (x < 7 && y < 7) || (x > 13 && y < 7) || (x < 7 && y > 13);
    for (int y = 0; y < n; y++) {
      for (int x = 0; x < n; x++) {
        if (finder(x, y)) {
          final lx = x % 14 > 6 ? x - 14 : x;
          final ly = y % 14 > 6 ? y - 14 : y;
          final ring = lx == 0 || lx == 6 || ly == 0 || ly == 6;
          final core = lx >= 2 && lx <= 4 && ly >= 2 && ly <= 4;
          if (ring || core) c.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), p);
        } else if (r.nextBool()) {
          c.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ============================================================
//  1. SPLASH
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Onboarding()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreen,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: const Icon(Icons.favorite_border, color: kGreen, size: 44),
          ),
          const SizedBox(height: 16),
          const Text('BuscaFarma',
              style: TextStyle(color: Colors.white, fontSize: 28)),
          const SizedBox(height: 8),
          const Text('Encuentra, reserva y recoge con calma',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      ),
    );
  }
}

// ============================================================
//  2-4. ONBOARDING
// ============================================================

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final ctrl = PageController();
  int page = 0;

  static const pages = [
    [Icons.search, 'Encuentra lo que necesitas',
      'Busca por marca o principio activo y confirma stock real cerca de ti.'],
    [Icons.savings_outlined, 'Compara y ahorra',
      'Revisa precios y alternativas genéricas seguras antes de elegir.'],
    [Icons.storefront_outlined, 'Reserva y recoge',
      'Paga de forma segura y recoge sin filas en tu botica elegida.'],
  ];

  @override
  Widget build(BuildContext context) {
    final last = page == 2;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => toHome(context),
                    child: const Text('Omitir'))),
            Expanded(
              child: PageView.builder(
                controller: ctrl,
                itemCount: 3,
                onPageChanged: (i) => setState(() => page = i),
                itemBuilder: (_, i) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kMint, borderRadius: BorderRadius.circular(24)),
                      child: Icon(pages[i][0] as IconData, size: 110, color: kGreen),
                    ),
                    const SizedBox(height: 28),
                    Text(pages[i][1] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 10),
                    Text(pages[i][2] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kGrey)),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  3,
                  (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(3),
                        width: i == page ? 22 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                            color: i == page ? kGreen : const Color(0xFFD5DCD9),
                            borderRadius: BorderRadius.circular(4)),
                      )),
            ),
            const SizedBox(height: 20),
            if (!last)
              Btn('Siguiente', () => ctrl.nextPage(
                  duration: const Duration(milliseconds: 300), curve: Curves.easeOut))
            else ...[
              Btn('Iniciar sesión', () => push(context, const LoginScreen())),
              const SizedBox(height: 10),
              Btn('Registrarme', () => push(context, const RegisterScreen())),
            ],
            TextButton(
                onPressed: () => toHome(context),
                child: const Text('Continuar como invitado',
                    style: TextStyle(fontSize: 12))),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
//  5. HOME (con barra inferior)
// ============================================================

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppState.tab,
      builder: (_, i, __) => Scaffold(
        body: SafeArea(
          child: IndexedStack(index: i, children: const [
            HomeTab(),
            SearchPage(embedded: true),
            SedesTab(),
            ReservasTab(),
            AccountTab(),
          ]),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          backgroundColor: Colors.white,
          indicatorColor: kMint,
          onDestinationSelected: (v) => AppState.tab.value = v,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
            NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Sedes'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Reservas'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Mi cuenta'),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('Buenos días, ${AppState.logged ? AppState.name : 'invitado'}',
          style: const TextStyle(fontSize: 12, color: kGrey)),
      const Text('¿Qué necesitas hoy?', style: TextStyle(fontSize: 24)),
      const SizedBox(height: 14),
      Box(
        onTap: () => AppState.tab.value = 1,
        Row(children: const [
          Icon(Icons.search, color: kGreen),
          SizedBox(width: 10),
          Expanded(
              child: Text('Nombre comercial o principio activo',
                  style: TextStyle(color: kGrey, fontSize: 13))),
          Icon(Icons.mic_none, color: kGrey),
        ]),
      ),
      Row(children: const [
        Icon(Icons.location_on_outlined, size: 16, color: kGreen),
        SizedBox(width: 4),
        Text('Cerca de Av. Larco 742, Miraflores',
            style: TextStyle(fontSize: 11, color: kGrey)),
      ]),
      const SizedBox(height: 16),
      const Text('Categorías comunes', style: TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: const [
        Pill('Dolor'), Pill('Resfrío'), Pill('Alergias'), Pill('Digestivo'),
      ]),
      const SizedBox(height: 16),
      if (AppState.logged)
        Box(
          color: kDark,
          onTap: () => AppState.tab.value = 3,
          Row(children: const [
            Icon(Icons.event_available_outlined, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('1 reserva activa',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              Text('Lista para retiro · 22 h restantes',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ])),
            Icon(Icons.chevron_right, color: Colors.white),
          ]),
        ),
      Text(AppState.logged ? 'Comprados anteriormente' : 'Populares cerca de ti',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      MedTile(meds[0]),
      if (!AppState.logged) MedTile(meds[2]),
    ]);
  }
}

// ============================================================
//  6-7. BÚSQUEDA, RESULTADOS Y RESULTADOS VACÍOS
// ============================================================

class SearchPage extends StatefulWidget {
  final bool embedded;
  const SearchPage({super.key, this.embedded = false});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final res = meds
        .where((m) =>
            m.name.toLowerCase().contains(q.toLowerCase()) ||
            m.active.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final empty = q.isNotEmpty && res.isEmpty;

    final body = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          autofocus: !widget.embedded,
          onChanged: (v) => setState(() => q = v.trim()),
          decoration: InputDecoration(
            hintText: 'Nombre comercial o principio activo',
            prefixIcon: const Icon(Icons.search, color: kGreen),
            suffixIcon: const Icon(Icons.mic_none),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 10),
        if (q.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
                child: Text('Escribe un medicamento, ej: "paracetamol"',
                    style: TextStyle(color: kGrey))),
          )
        else if (empty)
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('"$q"', style: const TextStyle(color: kGrey, fontSize: 12)),
              const SizedBox(height: 24),
              Container(
                width: 100,
                height: 100,
                decoration:
                    const BoxDecoration(color: kMint, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: kGreen, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('No encontramos esa presentación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text(
                  'Revisa la ortografía o prueba con el principio activo, o revisa estas alternativas disponibles cerca.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kGrey, fontSize: 12)),
              const SizedBox(height: 20),
              Btn('Ver alternativas equivalentes', () => setState(() => q = 'paracetamol')),
            ]),
          )
        else ...[
          Text('${res.length} resultados para "$q"',
              style: const TextStyle(fontSize: 12, color: kGrey)),
          const SizedBox(height: 8),
          Expanded(
              child: ListView(children: res.map((m) => MedTile(m)).toList())),
        ],
      ]),
    );

    if (widget.embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Resultados')), body: body);
  }
}

// ============================================================
//  8. DETALLE DE MEDICAMENTO
// ============================================================

class DetailScreen extends StatefulWidget {
  final Med med;
  const DetailScreen(this.med, {super.key});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool ahorro = true;
  @override
  Widget build(BuildContext context) {
    final m = widget.med;
    final alts = meds.where((x) => x.generic && x.active == m.active && x != m).toList();
    final more = meds.where((x) => x.active != m.active).take(2).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle'), actions: const [
        Icon(Icons.share_outlined), SizedBox(width: 12)
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          MedIcon(generic: m.generic, size: 96),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Text(m.active, style: const TextStyle(fontSize: 12, color: kGrey)),
            Text(m.pres, style: const TextStyle(fontSize: 12, color: kGrey)),
            const SizedBox(height: 4),
            Text('Desde ${money(m.price)}',
                style: const TextStyle(
                    color: kGreen, fontSize: 18, fontWeight: FontWeight.w600)),
          ])),
        ]),
        const SizedBox(height: 16),
        Box(
          color: kMint,
          Row(children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Filtro de Ahorro', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('Prioriza genéricos equivalentes',
                  style: TextStyle(fontSize: 11, color: kGrey)),
            ])),
            Switch(
                value: ahorro,
                activeColor: Colors.white,
                activeTrackColor: kDark,
                onChanged: (v) => setState(() => ahorro = v)),
          ]),
        ),
        if (ahorro && alts.isNotEmpty) ...[
          const SizedBox(height: 6),
          const Text('Alternativas genéricas',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...alts.map((a) => MedTile(a)),
          Row(children: [
            const Pill('Ahorras 39%', bg: kOrangeBg, fg: kOrangeText),
            const SizedBox(width: 8),
            Text('${money(m.price - alts.first.price)} menos por caja',
                style: const TextStyle(fontSize: 11, color: kGrey)),
          ]),
        ],
        const SizedBox(height: 16),
        const Text('También podría interesarte',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          for (final x in more)
            ActionChip(
                label: Text(x.name, style: const TextStyle(fontSize: 11)),
                onPressed: () => push(context, DetailScreen(x))),
        ]),
        const SizedBox(height: 20),
        Btn('Ver disponibilidad en boticas cercanas',
            () => push(context, NearbyScreen(m))),
      ]),
    );
  }
}

// ============================================================
//  9-10. DISPONIBILIDAD CERCANA + LOGIN PARA RESERVA
// ============================================================

class NearbyScreen extends StatelessWidget {
  final Med med;
  const NearbyScreen(this.med, {super.key});

  void reservar(BuildContext c, Sede s) {
    if (!AppState.logged) {
      showModalBottomSheet(
        context: c,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        builder: (_) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Inicia sesión para reservar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Guardaremos tu reserva y podrás pagar de forma segura.',
                style: TextStyle(color: kGrey, fontSize: 12)),
            const SizedBox(height: 16),
            Btn('Iniciar sesión / Registrarme', () {
              Navigator.pop(c);
              push(c, const LoginScreen());
            }),
            const SizedBox(height: 8),
          ]),
        ),
      );
    } else {
      push(c, QuantityScreen(med, s));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disponibilidad cercana')),
      body: Column(children: [
        const FakeMap(),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Text('${sedes.length} boticas con stock',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final s in sedes)
              Box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(money(med.price + s.extra),
                      style: const TextStyle(color: kGreen, fontWeight: FontWeight.w600)),
                ]),
                const Text('0.6 km · actualizado hace 4 minutos',
                    style: TextStyle(fontSize: 11, color: kGrey)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Pill('${s.units} unidades'),
                  ElevatedButton(
                    onPressed: () => reservar(context, s),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text('Reservar'),
                  ),
                ]),
              ])),
          ]),
        ),
      ]),
    );
  }
}

// ============================================================
//  11. SELECCIÓN DE CANTIDAD
// ============================================================

class QuantityScreen extends StatefulWidget {
  final Med med;
  final Sede sede;
  const QuantityScreen(this.med, this.sede, {super.key});
  @override
  State<QuantityScreen> createState() => _QuantityScreenState();
}

class _QuantityScreenState extends State<QuantityScreen> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    final m = widget.med, s = widget.sede;
    final unit = m.price + s.extra;
    return Scaffold(
      appBar: AppBar(title: const Text('Tu reserva')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const TimerBanner('Tienes 30 minutos para completar el pago', 30 * 60),
        Box(Row(children: [
          MedIcon(generic: m.generic),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${m.active} · ${m.pres}',
                style: const TextStyle(fontSize: 11, color: kGrey)),
          ])),
        ])),
        const SizedBox(height: 6),
        const Text('Cantidad', style: TextStyle(fontWeight: FontWeight.w600)),
        Row(children: [
          Expanded(
              child: Text('Máximo ${s.units} unidades disponibles',
                  style: const TextStyle(fontSize: 11, color: kGrey))),
          IconButton(
              onPressed: qty > 1 ? () => setState(() => qty--) : null,
              icon: const Icon(Icons.remove_circle_outline)),
          Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          IconButton(
              onPressed: qty < s.units ? () => setState(() => qty++) : null,
              icon: const Icon(Icons.add_circle_outline)),
        ]),
        Box(Row(children: [
          const Icon(Icons.storefront_outlined, color: kGreen),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${s.address} · 0.6 km',
                style: const TextStyle(fontSize: 11, color: kGrey)),
          ]),
        ])),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total'),
          Text(money(unit * qty),
              style: const TextStyle(
                  color: kGreen, fontSize: 22, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 16),
        Btn('Confirmar y pagar',
            () => push(context, PaymentScreen(m, s, qty))),
      ]),
    );
  }
}

// ============================================================
//  12-14. PAGO, ÉXITO Y RECHAZO
//  (Simulación: Visa = aprobado, Billetera digital = rechazado)
// ============================================================

class PaymentScreen extends StatefulWidget {
  final Med med;
  final Sede sede;
  final int qty;
  const PaymentScreen(this.med, this.sede, this.qty, {super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int method = 0;
  @override
  Widget build(BuildContext context) {
    final total = (widget.med.price + widget.sede.extra) * widget.qty;
    Widget opt(int i, IconData ic, String t) => Box(
          onTap: () => setState(() => method = i),
          Row(children: [
            Icon(ic, color: kGrey),
            const SizedBox(width: 10),
            Expanded(child: Text(t)),
            Icon(method == i ? Icons.radio_button_checked : Icons.radio_button_off,
                color: method == i ? kGreen : kGrey),
          ]),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Pagar reserva')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const TimerBanner('Tienes 30 minutos para completar el pago', 27 * 60 + 18),
        const Text('¿Cómo quieres pagar?',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        opt(0, Icons.credit_card, 'Visa terminada en 4281'),
        opt(1, Icons.account_balance_wallet_outlined, 'Billetera digital · Yape / Plin'),
        Box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${widget.med.name} × ${widget.qty} · ${money(total)}',
              style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
            Text(money(total),
                style: const TextStyle(
                    color: kGreen, fontSize: 18, fontWeight: FontWeight.w600)),
          ]),
        ])),
        const SizedBox(height: 10),
        Btn('Pagar ${money(total)}', () {
          if (method == 0) {
            final code = 'BC-${1000 + Random().nextInt(9000)}';
            final r = Reserva(code, widget.med, widget.sede, widget.qty, 'Pagada');
            AppState.reservas.insert(0, r);
            push(context, PaySuccess(r));
          } else {
            push(context, const PayRejected());
          }
        }),
        const SizedBox(height: 8),
        const Text('Demo: Visa = pago aprobado · Yape/Plin = pago rechazado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: kGrey)),
      ]),
    );
  }
}

class PaySuccess extends StatelessWidget {
  final Reserva r;
  const PaySuccess(this.r, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: kMint, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: kGreen, size: 48),
              ),
              const SizedBox(height: 18),
              const Text('¡Pago confirmado!', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                  'Tu pedido estará listo para recoger en ${r.sede.name}. Tienes 24 horas para retirarlo.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kGrey, fontSize: 12)),
              const SizedBox(height: 20),
              Box(
                padding: const EdgeInsets.all(18),
                Column(children: [
                  const Text('CÓDIGO DE RESERVA',
                      style: TextStyle(fontSize: 11, color: kGrey)),
                  Text(r.code,
                      style: const TextStyle(
                          fontSize: 32, color: kGreen, fontWeight: FontWeight.w500)),
                ]),
              ),
              const SizedBox(height: 10),
              Btn('Ver mi reserva', () => toHome(context, tab: 3)),
            ]),
          ),
        ),
      );
}

class PayRejected extends StatelessWidget {
  const PayRejected({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: kRedBg, shape: BoxShape.circle),
                child: const Icon(Icons.priority_high, color: kRed, size: 48),
              ),
              const SizedBox(height: 18),
              const Text('No pudimos procesar el pago', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 8),
              const Text('Tu tarjeta fue rechazada. Prueba otro medio sin perder la reserva.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kGrey, fontSize: 12)),
              const SizedBox(height: 20),
              const TimerBanner('Tienes 30 minutos para completar el pago', 23 * 60 + 6),
              Btn('Reintentar pago', () => Navigator.pop(context)),
            ]),
          ),
        ),
      );
}

// ============================================================
//  15-16. MIS RESERVAS + DETALLE DE RESERVA
// ============================================================

Color statusColor(String s) {
  switch (s) {
    case 'Cancelada':
      return kRed;
    case 'Expirada':
      return kGrey;
    case 'Reservada':
      return kOrangeText;
    default:
      return kGreen;
  }
}

class ReservasTab extends StatelessWidget {
  const ReservasTab({super.key});
  @override
  Widget build(BuildContext context) {
    if (!AppState.logged) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.shopping_bag_outlined, size: 56, color: kGreen),
            const SizedBox(height: 12),
            const Text('Inicia sesión para ver tus reservas',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Btn('Iniciar sesión', () => push(context, const LoginScreen())),
          ]),
        ),
      );
    }
    return Column(children: [
      AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Mis reservas'),
        actions: [
          IconButton(
              tooltip: 'Pendientes de pago',
              onPressed: () => push(context, const CartScreen()),
              icon: const Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          for (final r in AppState.reservas)
            Box(
              onTap: () => push(context, ReservaDetail(r)),
              Row(children: [
                const Icon(Icons.medication_outlined, color: kGrey),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${r.med.name} · ${r.code}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('${r.sede.name} · ${money(r.total)}',
                      style: const TextStyle(fontSize: 11, color: kGrey)),
                ])),
                Text(r.status,
                    style: TextStyle(
                        color: statusColor(r.status),
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
        ]),
      ),
    ]);
  }
}

class ReservaDetail extends StatelessWidget {
  final Reserva r;
  const ReservaDetail(this.r, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reserva ${r.code}')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          Icon(Icons.circle, size: 8, color: statusColor(r.status)),
          const SizedBox(width: 6),
          Text(r.status,
              style: TextStyle(
                  color: statusColor(r.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 10),
        Box(
          padding: const EdgeInsets.all(24),
          Column(children: [
            SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(painter: QrPainter(r.code))),
            const SizedBox(height: 10),
            Text(r.code, style: const TextStyle(fontSize: 22)),
          ]),
        ),
        const Text('22 h 14 min para recoger',
            style: TextStyle(color: kOrangeText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text(r.sede.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text('${r.sede.address} · Lima',
            style: const TextStyle(fontSize: 12, color: kGrey)),
        const SizedBox(height: 16),
        Btn('Cómo llegar', () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aquí se abriría el mapa con la ruta')))),
      ]),
    );
  }
}

// ============================================================
//  17. CARRITO MULTI-RESERVA
// ============================================================

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Widget item(String t, String sub, int secs, double price) => Box(
          Row(children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(sub, style: const TextStyle(fontSize: 11, color: kGrey)),
              Row(children: [
                const Text('Vence en ',
                    style: TextStyle(fontSize: 11, color: kOrangeText)),
                CountdownText(secs,
                    style: const TextStyle(fontSize: 11, color: kOrangeText)),
              ]),
            ])),
            Text(money(price), style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Pendientes de pago')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        item('Panadol Forte × 2', 'Boticas Salud Larco', 18 * 60 + 34, 25.80),
        item('Paracetamol Genfar', 'Boticas Salud Larco', 24 * 60 + 10, 7.90),
        const SizedBox(height: 6),
        Align(
            alignment: Alignment.centerRight,
            child: Text('Total ${money(33.70)}',
                style: const TextStyle(fontSize: 20))),
        const SizedBox(height: 12),
        Btn('Pagar todo · ${money(33.70)}', () {
          final r = Reserva('BC-${1000 + Random().nextInt(9000)}', meds[0], sedes[0], 2, 'Pagada');
          AppState.reservas.insert(0, r);
          push(context, PaySuccess(r));
        }),
      ]),
    );
  }
}

// ============================================================
//  18-19. SEDES CERCANAS Y DETALLE DE SEDE
// ============================================================

class SedesTab extends StatelessWidget {
  const SedesTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(automaticallyImplyLeading: false, title: const Text('Boticas cercanas')),
      const FakeMap(height: 190),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          const Text('Hasta 1 km · Abiertas ahora',
              style: TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final s in sedes)
            Box(
              onTap: () => push(context, SedeDetail(s)),
              Row(children: [
                const Icon(Icons.local_pharmacy_outlined, color: kGreen),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const Text('0.6 km · Abierta · stock disponible',
                      style: TextStyle(fontSize: 11, color: kGrey)),
                ])),
                const Icon(Icons.chevron_right, color: kGreen),
              ]),
            ),
        ]),
      ),
    ]);
  }
}

class SedeDetail extends StatelessWidget {
  final Sede s;
  const SedeDetail(this.s, {super.key});
  Widget row(IconData i, String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(i, color: kGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 13))),
        ]),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(s.name)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
              color: kMint, borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.storefront, size: 70, color: kGreen),
        ),
        const SizedBox(height: 12),
        const Text('● Abierta · cierra 10:00 p. m.',
            style: TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
        row(Icons.location_on_outlined, s.address),
        row(Icons.calendar_today_outlined, s.hours),
        row(Icons.phone_outlined, s.phone),
        const SizedBox(height: 8),
        Box(
          color: kMint,
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Stock destacado', style: TextStyle(fontWeight: FontWeight.w700)),
            Text('Panadol Forte · 8 unidades', style: TextStyle(fontSize: 12)),
            Text('Actualizado hace 4 minutos',
                style: TextStyle(fontSize: 11, color: kGrey)),
          ]),
        ),
        const SizedBox(height: 8),
        Btn('Ver medicamentos disponibles',
            () => push(context, const SearchPage())),
      ]),
    );
  }
}

// ============================================================
//  MI CUENTA (pestaña)
// ============================================================

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircleAvatar(
              radius: 36, backgroundColor: kMint,
              child: Icon(Icons.person, size: 40, color: kGreen)),
          const SizedBox(height: 12),
          Text(AppState.logged ? AppState.name : 'Invitado',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          if (AppState.logged)
            Btn('Cerrar sesión', () {
              AppState.logged = false;
              toHome(context);
            }, outline: true)
          else ...[
            Btn('Iniciar sesión', () => push(context, const LoginScreen())),
            const SizedBox(height: 10),
            Btn('Registrarme', () => push(context, const RegisterScreen()), outline: true),
          ],
        ]),
      ),
    );
  }
}

// ============================================================
//  19-20. LOGIN Y REGISTRO
//  Demo de roles:
//   - correo terminado en @boticassalud.pe  -> Rol detectado
//   - correo que contenga "colaborador"     -> Correo no autorizado
//   - cualquier otro                        -> cliente
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool hide = true;

  void submit() {
    final e = email.text.trim().toLowerCase();
    if (e.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ingresa tu correo')));
      return;
    }
    if (e.endsWith('@boticassalud.pe')) {
      push(context, RoleDetected(e));
    } else if (e.contains('colaborador')) {
      push(context, Unauthorized(e));
    } else {
      AppState.logged = true;
      toHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kBg, surfaceTintColor: kBg),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
        Row(children: const [
          Logo(),
          SizedBox(width: 10),
          Text('BuscaFarma', style: TextStyle(color: kGreen, fontSize: 20)),
        ]),
        const SizedBox(height: 14),
        const Text('Iniciar sesión', style: TextStyle(fontSize: 26)),
        const Text('Accede a tus reservas, compras y beneficios.',
            style: TextStyle(fontSize: 12, color: kGrey)),
        const SizedBox(height: 16),
        textField('Correo electrónico', Icons.mail_outline, 'nombre@correo.com', email,
            type: TextInputType.emailAddress),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Contraseña',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            TextField(
              controller: pass,
              obscureText: hide,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20, color: kGrey),
                suffixIcon: IconButton(
                    icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => hide = !hide)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E6E3))),
              ),
            ),
          ]),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {},
                child: const Text('¿Olvidaste tu contraseña?',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)))),
        Btn('Ingresar', submit),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(child: Text('o', style: TextStyle(color: kGrey)))),
        Btn('Continuar con Google', () {
          AppState.logged = true;
          toHome(context);
        }, outline: true),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('¿No tienes cuenta?', style: TextStyle(fontSize: 12, color: kGrey)),
          TextButton(
              onPressed: () => push(context, const RegisterScreen()),
              child: const Text('Regístrate',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
        ]),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: kMint, borderRadius: BorderRadius.circular(12)),
          child: Row(children: const [
            Icon(Icons.info_outline, color: kGreen, size: 18),
            SizedBox(width: 8),
            Expanded(
                child: Text(
                    '¿Eres personal de una botica afiliada? Ingresa con tu correo corporativo — el sistema reconoce tu rol automáticamente.',
                    style: TextStyle(fontSize: 11, color: kGreen))),
          ]),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombre = TextEditingController();
  final email = TextEditingController();
  final tel = TextEditingController();
  final pass = TextEditingController();
  bool ok = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kBg, surfaceTintColor: kBg),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 20), children: [
        Row(children: const [
          Logo(),
          SizedBox(width: 10),
          Text('BuscaFarma', style: TextStyle(color: kGreen, fontSize: 20)),
        ]),
        const SizedBox(height: 14),
        const Text('Crea tu cuenta', style: TextStyle(fontSize: 26)),
        const Text('Reserva tus medicamentos y recógelos cerca de ti.',
            style: TextStyle(fontSize: 12, color: kGrey)),
        const SizedBox(height: 16),
        textField('Nombre completo', Icons.person_outline, 'Mariana Torres', nombre),
        textField('Correo electrónico', Icons.mail_outline, 'mariana@correo.com', email,
            type: TextInputType.emailAddress),
        textField('Teléfono', Icons.phone_outlined, '987 654 321', tel,
            type: TextInputType.phone),
        textField('Contraseña', Icons.lock_outline, 'Mínimo 8 caracteres', pass,
            obscure: true),
        Row(children: [
          Checkbox(
              value: ok,
              activeColor: kGreen,
              onChanged: (v) => setState(() => ok = v ?? false)),
          const Expanded(
              child: Text('Acepto los Términos y condiciones y la Política de privacidad.',
                  style: TextStyle(fontSize: 11))),
        ]),
        const SizedBox(height: 8),
        Btn('Crear cuenta', ok
            ? () {
                AppState.logged = true;
                if (nombre.text.trim().isNotEmpty) {
                  AppState.name = nombre.text.trim().split(' ').first;
                }
                toHome(context);
              }
            : null),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('¿Ya tienes cuenta?', style: TextStyle(fontSize: 12, color: kGrey)),
          TextButton(
              onPressed: () => push(context, const LoginScreen()),
              child: const Text('Inicia sesión',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
        ]),
      ]),
    );
  }
}

// ============================================================
//  21-22. ROL DETECTADO / CORREO NO AUTORIZADO
// ============================================================

class RoleDetected extends StatelessWidget {
  final String email;
  const RoleDetected(this.email, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kBg, surfaceTintColor: kBg),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: const [
          Logo(),
          SizedBox(width: 10),
          Text('BuscaFarma', style: TextStyle(color: kGreen, fontSize: 20)),
        ]),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(color: kMint, shape: BoxShape.circle),
            child: const Icon(Icons.verified_outlined, color: kGreen, size: 40),
          ),
        ),
        const SizedBox(height: 10),
        const Center(child: Pill('Cuenta de personal de botica')),
        const SizedBox(height: 10),
        const Center(child: Text('¡Hola, Diego!', style: TextStyle(fontSize: 24))),
        const SizedBox(height: 6),
        const Text('Reconocimos tu correo corporativo y encontramos tu lugar de trabajo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: kGrey)),
        const SizedBox(height: 16),
        Box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Boticas Salud Larco', style: TextStyle(fontWeight: FontWeight.w700)),
          const Text('Sede Miraflores · Av. Larco 742',
              style: TextStyle(fontSize: 11, color: kGrey)),
          const SizedBox(height: 8),
          Text(email, style: const TextStyle(fontSize: 12)),
        ])),
        const SizedBox(height: 8),
        Btn('Continuar al panel de gestión', () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('El panel de gestión no está incluido en esta demo')))),
        const SizedBox(height: 10),
        Btn('No soy yo, usar otra cuenta', () => Navigator.pop(context), outline: true),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Tu acceso y permisos se asignaron según la información registrada por la botica.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: kGrey)),
        ),
      ]),
    );
  }
}

class Unauthorized extends StatelessWidget {
  final String email;
  const Unauthorized(this.email, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kBg, surfaceTintColor: kBg),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: const [
          Logo(),
          SizedBox(width: 10),
          Text('BuscaFarma', style: TextStyle(color: kGreen, fontSize: 20)),
        ]),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(color: kRedBg, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: kRed, size: 40),
          ),
        ),
        const SizedBox(height: 10),
        const Center(child: Text('Correo no autorizado', style: TextStyle(fontSize: 24))),
        const SizedBox(height: 6),
        const Text('No encontramos este correo en la lista de personal habilitado por una botica afiliada.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: kGrey)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: kRedBg, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.error_outline, color: kRed, size: 18),
            const SizedBox(width: 8),
            Text(email, style: const TextStyle(color: kRed, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 12),
        Box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('¿Deberías tener acceso?', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Pide a tu administrador que valide tu correo.',
              style: TextStyle(fontSize: 11, color: kGrey)),
          SizedBox(height: 8),
          Text('SOPORTE BUSCAFARMA', style: TextStyle(fontSize: 10, color: kGrey)),
          Text('soporte@buscafarma.pe',
              style: TextStyle(color: kGreen, fontWeight: FontWeight.w700)),
          Text('Lun–sáb · 8:00 a 20:00', style: TextStyle(fontSize: 11, color: kGrey)),
        ])),
        Btn('Intentar con otro correo', () => Navigator.pop(context)),
        const SizedBox(height: 10),
        Btn('Continuar como cliente', () {
          AppState.logged = true;
          toHome(context);
        }, outline: true),
        const Padding(
          padding: EdgeInsets.only(top: 14),
          child: Text('Puedes usar BuscaFarma como cliente con este mismo correo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: kGrey)),
        ),
      ]),
    );
  }
}

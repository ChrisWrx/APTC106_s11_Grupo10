import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/viajes_list_screen.dart';
import 'screens/viaje_detail_screen.dart';
import 'screens/viaje_form_screen.dart';
import 'screens/estadisticas_screen.dart';
import 'screens/ajustes_screen.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

final themeProvider = ThemeProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const RutaLogApp());
}

class RutaLogApp extends StatefulWidget {
  const RutaLogApp({super.key});

  @override
  State<RutaLogApp> createState() => _RutaLogAppState();
}

class _RutaLogAppState extends State<RutaLogApp> {
  @override
  void initState() {
    super.initState();
    themeProvider.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RutaLog',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFF97316),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1E3A8A),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF3B82F6),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFFF97316),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3B82F6),
        ),
        cardColor: const Color(0xFF1E293B),
      ),
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/viajes': (context) => const ViajesListScreen(),
        '/nuevo-viaje': (context) => const ViajeFormScreen(),
        '/estadisticas': (context) => const EstadisticasScreen(),
        '/ajustes': (context) => const AjustesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detalle-viaje') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ViajeDetailScreen(viaje: args['viaje']),
          );
        }
        if (settings.name == '/editar-viaje') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ViajeFormScreen(viaje: args['viaje']),
          );
        }
        return null;
      },
    );
  }
}

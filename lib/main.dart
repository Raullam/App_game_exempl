import 'package:flutter/material.dart';
import 'package:flutter_loggin/provider/crypto_provider.dart';
import 'package:flutter_loggin/provider/plantesProvider.dart';
import 'package:flutter_loggin/provider/usuarisProvider.dart';
import 'package:flutter_loggin/provider/theme_provider.dart'; // Importa el ThemeProvider
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'ca', null); // Inicialitza la configuració per català
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => UsuarisProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => CryptoProvider()),
        ChangeNotifierProvider(create: (_) => PlantaProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Añadimos el ThemeProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Registre',
            theme: ThemeData(
              primaryColor: Colors.red,
              scaffoldBackgroundColor: themeProvider
                  .backgroundColor, // Establecemos el color de fondo
            ),
            initialRoute: Rutes.paginaPrincipal,
            routes: Rutes.obtenerRutas(),
          );
        },
      ),
    );
  }
}

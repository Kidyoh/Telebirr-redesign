import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/shell.dart';
import 'theme/tokens.dart';
import 'theme/type.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  runApp(const TelebirrApp());
}

class TelebirrApp extends StatelessWidget {
  const TelebirrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'telebirr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: TType.sans,
        scaffoldBackgroundColor: TB.ground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TB.brand,
          primary: TB.brandDeep,
          surface: TB.surface,
          onSurface: TB.ink,
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: TB.brandDeep,
        ),
      ),
      home: const Shell(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/helper/routes.dart';
import 'package:tezda/providers/expandable_text.dart';
import 'package:tezda/providers/product_provider.dart';
import 'package:tezda/screen/splash_screen.dart';
import 'package:tezda/state/auth_state.dart';
import 'package:tezda/theme/colour.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpandText(),
        ),
      ],
      child: MaterialApp(
        title: 'Tezda',
        theme: ThemeData(
          primaryColor: AppColour.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColour.primary),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: ((settings) => generateRoute(settings)),
        home: const SplashScreen(),
      ),
    );
  }
}

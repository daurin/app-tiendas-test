import 'package:app_tiendas/src/views/pages/home/home.page.dart';
import 'package:app_tiendas/src/views/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
BuildContext get navigatorContext => _navigatorKey.currentContext!;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: blocs,
      child: MaterialApp(
        restorationScopeId: 'app',
        navigatorKey: _navigatorKey,
        home: HomePage(),
      ),
    );
  }
}

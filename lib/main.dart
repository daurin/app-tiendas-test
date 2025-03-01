import 'package:app_tiendas/injector.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initDependenciesInjector();

  runApp(App());
}

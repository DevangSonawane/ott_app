import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'env/app_env.dart';
import 'services/web_content_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());

  if (isDebug) {
    try {
      // Optional debug-only sanity check. Some Flutter builds may not bundle the
      // JSON manifest; don't treat it as fatal.
      await rootBundle.loadString('AssetManifest.json');
    } catch (_) {}
    try {
      await WebContentRepository.load();
    } catch (_) {}
  }
  await Hive.initFlutter();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(
    const ProviderScope(
      child: CamcineApp(),
    ),
  );
}

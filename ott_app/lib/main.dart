import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'services/web_content_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final manifestRaw = await rootBundle.loadString('AssetManifest.json');
    final manifest = jsonDecode(manifestRaw) as Map<String, dynamic>;
    debugPrint('AssetManifest public/ count: '
        '${manifest.keys.where((k) => k.startsWith('public/')).length}');
    for (final k in const [
      'public/content.json',
      'public/hero-stranger-things.jpg',
      'public/Continue Watching/Friends.png',
      'public/Top Movies/Dhadak 2.png',
    ]) {
      final exists = manifest.containsKey(k);
      debugPrint('Asset exists [$k] = $exists');
      if (!exists) {
        final needle = k.split('/').last;
        final matches = manifest.keys
            .where((x) => x.toLowerCase().contains(needle.toLowerCase()))
            .take(8)
            .toList(growable: false);
        debugPrint('Closest matches for [$needle]: $matches');
      }
    }
  } catch (e) {
    debugPrint('AssetManifest read failed: $e');
  }
  try {
    final web = await WebContentRepository.load();
    debugPrint(
      'WEB content loaded: hero=${web.heroSlides.length}, continue=${web.continueWatching.length}, trending=${web.trendingNow.length}, top10=${web.top10.length}',
    );
  } catch (e) {
    debugPrint('WEB content load failed: $e');
  }
  await Hive.initFlutter();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(
    const ProviderScope(
      child: TheFlashxApp(),
    ),
  );
}

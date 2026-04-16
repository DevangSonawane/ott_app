package com.example.ott_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Defensive plugin registration: some OEM builds/dev flows can skip the
        // automatic registrant, which breaks platform views like WebView.
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}

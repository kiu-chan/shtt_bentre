import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/app.dart';
import 'package:provider/provider.dart';
import 'package:shtt_bentre/src/providers/language_provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    )
  );
}
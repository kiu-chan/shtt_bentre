import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shtt_bentre/src/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: languageProvider.currentLanguage,
              items:  [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(AppLocalizations.of(context)!.english),
                ),
                DropdownMenuItem(
                  value: 'vi',
                  child: Text(AppLocalizations.of(context)!.vietnamese),
                ),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
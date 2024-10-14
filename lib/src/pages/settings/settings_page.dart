import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shtt_bentre/src/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: localizations.accountSettings,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(localizations.loginOrRegister),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: localizations.appSettings,
            children: [
              ListTile(
                leading: Icon(Icons.language),
                title: Text(localizations.language),
                trailing: DropdownButton<String>(
                  value: languageProvider.currentLanguage,
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(localizations.english),
                    ),
                    DropdownMenuItem(
                      value: 'vi',
                      child: Text(localizations.vietnamese),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      languageProvider.changeLanguage(value);
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            title: localizations.about,
            children: [
              ListTile(
                leading: Icon(Icons.info),
                title: Text(localizations.appVersion),
                trailing: Text('1.0.0'), // Replace with actual version
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...children,
        Divider(),
      ],
    );
  }
}

// Placeholder for LoginPage
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Center(
        child: Text('Login page content goes here'),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/pages/home/home_page.dart';
import 'package:shtt_bentre/src/pages/map/map_page.dart';
import 'package:shtt_bentre/src/pages/settings/settings_page.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});
  @override
  SelectPageState createState() => SelectPageState();
}

class SelectPageState extends State<SelectPage> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomePage(),
      const MapPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Container(
          color: Colors.white,
          key: ValueKey<int>(currentIndex),
          child: pages[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            label: AppLocalizations.of(context)!.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}
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

class SelectPageState extends State<SelectPage> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomePage(),
      const MapPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<int>(currentIndex),
                  child: pages[currentIndex],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                currentIndex = index;
                _controller.forward(from: 0);
              });
            },
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey.shade400,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            items: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: AppLocalizations.of(context)!.home,
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.map_rounded,
                label: AppLocalizations.of(context)!.map,
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.settings_rounded,
                label: AppLocalizations.of(context)!.settings,
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          icon,
          size: 24,
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          icon,
          size: 28,
        ),
      ),
      label: label,
    );
  }
}
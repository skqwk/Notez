import 'package:flutter/material.dart';
import 'package:notez/presentation/page/list_note_page.dart';
import 'package:notez/presentation/page/profile_page.dart';
import 'package:notez/presentation/page/settings_page.dart';

List<Widget Function()> pages = [
  () => const ProfilePage(),
  () => const ListNotePage(),
  () => const SettingsPage(),
];

class MainPage extends StatefulWidget {
  static const String route = '/main-page';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            extended: true,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Профиль'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notes),
                label: Text('Заметки'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Настройки'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) => setState(() {
              selectedIndex = value;
            }),
          )),
          Expanded(
              child: Container(
            color: Colors.orange,
            child: buildPage(selectedIndex),
          )),
        ],
      ),
    );
  }

  Widget buildPage(int selectedIndex) {
     return pages[selectedIndex].call();
  }
}

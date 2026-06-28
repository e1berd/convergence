import 'package:declar_ui/declar_ui.dart';

import '../i18n/strings.g.dart';
import 'screens/activity_screen.dart';
import 'screens/devices_screen.dart';
import 'screens/folders_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/status_screen.dart';
import 'widgets/engine_chip.dart';
import 'widgets/expressive.dart';
import 'widgets/side_rail.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    StatusScreen(),
    FoldersScreen(),
    DevicesScreen(),
    ActivityScreen(),
    SettingsScreen(),
  ];

  List<RailDestination> _destinations(Translations t) => [
    RailDestination(
      Icons.dashboard_outlined,
      Icons.dashboard_rounded,
      t.nav.status,
    ),
    RailDestination(Icons.folder_outlined, Icons.folder_rounded, t.nav.folders),
    RailDestination(
      Icons.devices_outlined,
      Icons.devices_rounded,
      t.nav.devices,
    ),
    RailDestination(Icons.bolt_outlined, Icons.bolt_rounded, t.nav.activity),
    RailDestination(
      Icons.settings_outlined,
      Icons.settings_rounded,
      t.nav.settings,
    ),
  ];

  void _select(int next) => setState(() => _index = next);

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations(context.t);
    final colors = context.colors;
    final titles = [
      context.t.nav.status,
      context.t.nav.folders,
      context.t.nav.devices,
      context.t.nav.activity,
      context.t.nav.settings,
    ];
    final pages = ExpressiveLazyStack(
      index: _index,
      length: _screens.length,
      itemBuilder: (i) => _screens[i],
    );

    if (context.width >= expressiveCompactBreakpoint) {
      return Scaffold().body(
        Row(
          children: [
            SideRail(
              destinations: destinations,
              selectedIndex: _index,
              onSelected: _select,
            ),
            VerticalDivider(width: 1, color: colors.outlineVariant),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 26, 28, 4),
                    child: Row(
                      children: [
                        Text(titles[_index]).size(28).weight(.w800),
                        const Spacer(),
                        const EngineChip(),
                      ],
                    ),
                  ),
                  Expanded(child: pages),
                ],
              ),
            ),
          ],
        ).crossAlign(.stretch),
      );
    }

    return Scaffold()
        .appBar(
          AppBar(
            title: Text(titles[_index]).weight(.w800),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(child: EngineChip()),
              ),
            ],
          ),
        )
        .body(pages)
        .bottomNavigation(
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _select,
            destinations: [
              for (final d in destinations)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
            ],
          ),
        );
  }
}

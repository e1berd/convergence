import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../i18n/strings.g.dart';
import '../../state/config_provider.dart';
import '../../state/options_providers.dart';
import '../widgets/expressive.dart';
import '../widgets/palette_picker.dart';
import '../widgets/setting_tile.dart';
import 'engine_settings.dart';
import 'gui_auth_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final notifier = ref.read(configProvider.notifier);
    final t = context.t;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: ExpressiveResponsiveCenter(
          maxWidth: 860,
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              ExpressiveSection(
                title: t.settings.appearance,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, c) => M3EToggleButtonGroup(
                        actions: [
                          M3EToggleButtonGroupAction(
                            icon: const Icon(Icons.brightness_auto_rounded),
                            width: _segWidth(c.maxWidth, 3),
                          ),
                          M3EToggleButtonGroupAction(
                            icon: const Icon(Icons.light_mode_rounded),
                            width: _segWidth(c.maxWidth, 3),
                          ),
                          M3EToggleButtonGroupAction(
                            icon: const Icon(Icons.dark_mode_rounded),
                            width: _segWidth(c.maxWidth, 3),
                          ),
                        ],
                        type: .connected,
                        size: .sm,
                        style: .tonal,
                        selectedIndex: config.themeMode.index,
                        onSelectedIndexChanged: (i) {
                          if (i != null) {
                            notifier.setThemeMode(ThemeMode.values[i]);
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                    child: PalettePicker(
                      selectedId: config.themeSchemeId,
                      onSelected: notifier.setThemeScheme,
                    ),
                  ),
                ],
              ),
              ExpressiveSection(
                title: t.settings.languageTitle,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, c) => M3EToggleButtonGroup(
                        actions: [
                          M3EToggleButtonGroupAction(
                            label: Text(t.settings.languageEnglish),
                            width: _segWidth(c.maxWidth, 2),
                          ),
                          M3EToggleButtonGroupAction(
                            label: Text(t.settings.languageRussian),
                            width: _segWidth(c.maxWidth, 2),
                          ),
                        ],
                        type: .connected,
                        size: .sm,
                        style: .tonal,
                        selectedIndex:
                            LocaleSettings.currentLocale == AppLocale.en
                            ? 0
                            : 1,
                        onSelectedIndexChanged: (i) {
                          if (i != null) {
                            notifier.setLocale(
                              i == 0 ? AppLocale.en : AppLocale.ru,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const EngineSettings(),
              const GuiAuthSettings(),
              const _NetworkSection(),
            ],
          ),
        ),
      ),
    );
  }
}

double _segWidth(double maxWidth, int count) {
  final usable = maxWidth - (count - 1) * 2 - 4;
  return usable / count;
}

class _NetworkSection extends ConsumerWidget {
  const _NetworkSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t.settings;
    final options = ref.watch(optionsProvider).value ?? const {};
    final controller = ref.read(optionsControllerProvider);

    bool flag(String key, bool fallback) => options[key] as bool? ?? fallback;

    return ExpressiveSection(
      title: t.network,
      children: [
        SettingTile(
          icon: Icons.public_rounded,
          title: t.globalDiscoveryTitle,
          subtitle: t.globalDiscoverySubtitle,
          trailing: Switch(
            value: flag('globalAnnounceEnabled', true),
            onChanged: (v) => controller.setFlag('globalAnnounceEnabled', v),
          ),
        ),
        SettingTile(
          icon: Icons.wifi_rounded,
          title: t.localDiscoveryTitle,
          subtitle: t.localDiscoverySubtitle,
          trailing: Switch(
            value: flag('localAnnounceEnabled', true),
            onChanged: (v) => controller.setFlag('localAnnounceEnabled', v),
          ),
        ),
        SettingTile(
          icon: Icons.hub_rounded,
          title: t.relaysTitle,
          subtitle: t.relaysSubtitle,
          trailing: Switch(
            value: flag('relaysEnabled', true),
            onChanged: (v) => controller.setFlag('relaysEnabled', v),
          ),
        ),
        SettingTile(
          icon: Icons.router_rounded,
          title: t.natTitle,
          subtitle: t.natSubtitle,
          trailing: Switch(
            value: flag('natEnabled', true),
            onChanged: (v) => controller.setFlag('natEnabled', v),
          ),
        ),
      ],
    );
  }
}

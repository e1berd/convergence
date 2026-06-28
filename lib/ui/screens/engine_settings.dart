import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../core/config.dart';
import '../../engine/binary_locator.dart';
import '../../i18n/strings.g.dart';
import '../../state/config_provider.dart';
import '../../state/engine_providers.dart';
import '../widgets/expressive.dart';
import '../widgets/setting_tile.dart';
import '../widgets/text_field.dart';

class EngineSettings extends ConsumerStatefulWidget {
  const EngineSettings({super.key});

  @override
  ConsumerState<EngineSettings> createState() => _EngineSettingsState();
}

class _EngineSettingsState extends ConsumerState<EngineSettings> {
  late final TextEditingController _url;
  late final TextEditingController _key;

  @override
  void initState() {
    super.initState();
    final config = ref.read(configProvider);
    _url = TextEditingController(text: config.remoteUrl);
    _key = TextEditingController(text: config.remoteApiKey);
  }

  @override
  void dispose() {
    _url.dispose();
    _key.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.engine;
    final config = ref.watch(configProvider);
    final notifier = ref.read(configProvider.notifier);
    final remote = config.engineMode == EngineMode.remote;

    return ExpressiveSection(
      title: context.t.settings.engine,
      children: [
        if (engineSupportsBundled)
          SettingTile(
            icon: Icons.memory_rounded,
            title: t.bundledTitle,
            subtitle: t.bundledSubtitle,
            trailing: Switch(
              value: !remote,
              onChanged: (v) => notifier.setEngineMode(
                v ? EngineMode.bundled : EngineMode.remote,
              ),
            ),
          ),
        SettingTile(
          icon: Icons.cloud_rounded,
          title: t.remoteTitle,
          subtitle: t.remoteSubtitle,
          trailing: Switch(
            value: remote,
            onChanged: (v) => notifier.setEngineMode(
              v ? EngineMode.remote : EngineMode.bundled,
            ),
          ),
        ),
        if (remote)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                ExpressiveTextField(
                  controller: _url,
                  label: t.remoteUrl,
                  hint: 'http://127.0.0.1:8384',
                ),
                ExpressiveTextField(
                  controller: _key,
                  label: t.remoteApiKey,
                  obscure: true,
                ),
                FilledButton(
                  onPressed: () =>
                      notifier.setRemote(_url.text.trim(), _key.text.trim()),
                  child: Text(t.apply),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: M3EButton.icon(
                  onPressed: () => ref.read(supervisorProvider).restart(),
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: Text(t.restart),
                  style: .tonal,
                ),
              ),
              Expanded(
                child: M3EButton.icon(
                  onPressed: () => ref.read(supervisorProvider).stop(),
                  icon: const Icon(Icons.power_settings_new_rounded),
                  label: Text(t.shutdown),
                  style: .tonal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

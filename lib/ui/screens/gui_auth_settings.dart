import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../i18n/strings.g.dart';
import '../../state/gui_providers.dart';
import '../widgets/expressive.dart';
import '../widgets/text_field.dart';

class GuiAuthSettings extends ConsumerStatefulWidget {
  const GuiAuthSettings({super.key});

  @override
  ConsumerState<GuiAuthSettings> createState() => _GuiAuthSettingsState();
}

class _GuiAuthSettingsState extends ConsumerState<GuiAuthSettings> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  String _loadedUser = '';

  @override
  void initState() {
    super.initState();
    _user.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  void _syncUser(String user) {
    if (user != _loadedUser) {
      _loadedUser = user;
      _user.text = user;
    }
  }

  Future<void> _save() async {
    await ref
        .read(guiControllerProvider)
        .setAuth(_user.text.trim(), _password.text);
    _password.clear();
    if (mounted) context.showSnackBar(context.t.settings.guiAuthSaved);
  }

  Future<void> _disable() async {
    await ref.read(guiControllerProvider).clearAuth();
    _user.clear();
    _password.clear();
    _loadedUser = '';
    if (mounted) context.showSnackBar(context.t.settings.guiAuthSaved);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.settings;
    final colors = context.colors;
    final gui = ref.watch(guiConfigProvider).value ?? const {};
    final currentUser = gui['user'] as String? ?? '';
    final configured = currentUser.isNotEmpty;
    _syncUser(currentUser);

    return ExpressiveSection(
      title: t.security,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 14,
            children: [
              Row(
                children: [
                  Icon(
                    configured ? Icons.lock_rounded : Icons.lock_open_rounded,
                    size: 18,
                    color: configured ? colors.primary : colors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child:
                        Text(
                              configured
                                  ? t.guiAuthConfigured
                                  : t.guiAuthNotConfigured,
                            )
                            .size(13)
                            .weight(.w700)
                            .color(
                              configured ? colors.onSurface : colors.error,
                            ),
                  ),
                ],
              ),
              Text(t.guiAuthSubtitle).size(13).color(colors.onSurfaceVariant),
              ExpressiveTextField(controller: _user, label: t.guiUser),
              ExpressiveTextField(
                controller: _password,
                label: t.guiPassword,
                hint: configured ? t.guiPasswordHint : null,
                obscure: true,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _user.text.trim().isEmpty ? null : _save,
                      child: Text(context.t.common.save),
                    ),
                  ),
                  if (configured)
                    M3EButton(
                      onPressed: _disable,
                      style: .tonal,
                      child: Text(t.guiClear),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

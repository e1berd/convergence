import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'engine_providers.dart';

final guiConfigProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return const {};
  return client.gui();
});

final guiControllerProvider = Provider(GuiController.new);

class GuiController {
  GuiController(this._ref);

  final Ref _ref;

  Future<void> setAuth(String user, String password) async {
    final client = _ref.read(clientProvider);
    if (client == null) return;
    final gui = Map<String, dynamic>.from(await client.gui());
    gui['user'] = user;
    if (password.isNotEmpty) gui['password'] = password;
    await client.putGui(gui);
    _ref.invalidate(guiConfigProvider);
  }

  Future<void> clearAuth() async {
    final client = _ref.read(clientProvider);
    if (client == null) return;
    final gui = Map<String, dynamic>.from(await client.gui());
    gui['user'] = '';
    gui['password'] = '';
    await client.putGui(gui);
    _ref.invalidate(guiConfigProvider);
  }
}

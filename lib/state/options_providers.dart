import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'engine_providers.dart';

final optionsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return const {};
  return client.options();
});

final optionsControllerProvider = Provider(OptionsController.new);

class OptionsController {
  OptionsController(this._ref);

  final Ref _ref;

  Future<void> setFlag(String key, bool value) async {
    final client = _ref.read(clientProvider);
    if (client == null) return;
    final options = Map<String, dynamic>.from(await client.options());
    options[key] = value;
    await client.putOptions(options);
    _ref.invalidate(optionsProvider);
  }

  Future<void> setInt(String key, int value) async {
    final client = _ref.read(clientProvider);
    if (client == null) return;
    final options = Map<String, dynamic>.from(await client.options());
    options[key] = value;
    await client.putOptions(options);
    _ref.invalidate(optionsProvider);
  }
}

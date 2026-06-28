import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/syncthing_models.dart';
import 'engine_providers.dart';

final systemStatusProvider = FutureProvider<SystemStatus?>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return null;
  return client.systemStatus();
});

final systemVersionProvider = FutureProvider<SystemVersion?>((ref) async {
  final client = ref.watch(clientProvider);
  if (client == null) return null;
  return client.systemVersion();
});

final connectionsProvider = FutureProvider<Connections?>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return null;
  return client.connections();
});

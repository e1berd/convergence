import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/event_stream.dart';
import '../api/syncthing_client.dart';
import '../api/syncthing_models.dart';
import '../core/config.dart';
import '../engine/binary_locator.dart';
import '../engine/bundled_supervisor.dart';
import '../engine/remote_supervisor.dart';
import '../engine/syncthing_supervisor.dart';
import 'config_provider.dart';

final supervisorProvider = Provider<SyncthingSupervisor>((ref) {
  final mode = ref.watch(configProvider.select((c) => c.engineMode));
  final url = ref.watch(configProvider.select((c) => c.remoteUrl));
  final apiKey = ref.watch(configProvider.select((c) => c.remoteApiKey));

  final SyncthingSupervisor supervisor;
  if (mode == EngineMode.remote || !engineSupportsBundled) {
    supervisor = RemoteSupervisor(url: url, apiKey: apiKey);
  } else {
    supervisor = BundledSupervisor();
  }
  supervisor.start();
  ref.onDispose(supervisor.stop);
  return supervisor;
});

final engineStatusProvider = StreamProvider<EngineStatus>((ref) async* {
  final supervisor = ref.watch(supervisorProvider);
  yield supervisor.current;
  yield* supervisor.status;
});

final endpointProvider = Provider<SyncEndpoint?>((ref) {
  return ref.watch(engineStatusProvider).value?.endpoint;
});

final clientProvider = Provider<SyncthingClient?>((ref) {
  final endpoint = ref.watch(endpointProvider);
  if (endpoint == null) return null;
  final client = SyncthingClient(endpoint: endpoint);
  ref.onDispose(client.close);
  return client;
});

final eventStreamProvider = StreamProvider<SyncEvent>((ref) {
  final client = ref.watch(clientProvider);
  if (client == null) return const Stream.empty();
  final stream = SyncthingEventStream(client);
  stream.start();
  ref.onDispose(stream.stop);
  return stream.stream;
});

final refreshTickProvider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();
  var tick = 0;
  controller.add(tick);
  final timer = Timer.periodic(
    const Duration(seconds: 8),
    (_) => controller.add(++tick),
  );
  final sub = ref.listen(eventStreamProvider, (_, _) => controller.add(++tick));
  ref.onDispose(() {
    timer.cancel();
    sub.close();
    controller.close();
  });
  return controller.stream;
});

final engineLogProvider = StreamProvider<String>((ref) {
  final supervisor = ref.watch(supervisorProvider);
  return supervisor.logs;
});

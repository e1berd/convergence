import '../api/syncthing_models.dart';

enum EngineState { idle, starting, running, error, remote, stopped }

class EngineStatus {
  const EngineStatus(this.state, {this.endpoint, this.message});

  final EngineState state;
  final SyncEndpoint? endpoint;
  final String? message;

  bool get isReady =>
      endpoint != null &&
      (state == EngineState.running || state == EngineState.remote);
}

abstract class SyncthingSupervisor {
  Stream<EngineStatus> get status;
  EngineStatus get current;
  Stream<String> get logs;

  Future<void> start();
  Future<void> stop();
  Future<void> restart();
}

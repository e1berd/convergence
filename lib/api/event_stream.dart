import 'dart:async';

import 'syncthing_client.dart';

class SyncEvent {
  const SyncEvent({required this.id, required this.type, required this.data});

  final int id;
  final String type;
  final Map<String, dynamic> data;
}

class SyncthingEventStream {
  SyncthingEventStream(this._client);

  final SyncthingClient _client;
  final _controller = StreamController<SyncEvent>.broadcast();
  bool _running = false;
  int _since = 0;

  Stream<SyncEvent> get stream => _controller.stream;

  void start() {
    if (_running) return;
    _running = true;
    _loop();
  }

  Future<void> _loop() async {
    while (_running) {
      try {
        final raw = await _client.events(since: _since);
        for (final item in raw) {
          final map = (item as Map).cast<String, dynamic>();
          final id = (map['id'] as num? ?? 0).toInt();
          if (id > _since) _since = id;
          _controller.add(
            SyncEvent(
              id: id,
              type: map['type'] as String? ?? '',
              data: (map['data'] as Map?)?.cast<String, dynamic>() ?? const {},
            ),
          );
        }
      } on Object {
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
  }

  void stop() {
    _running = false;
    _controller.close();
  }
}

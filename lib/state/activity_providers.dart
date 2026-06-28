import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/event_stream.dart';
import 'engine_providers.dart';

final recentEventsProvider = NotifierProvider<RecentEvents, List<SyncEvent>>(
  RecentEvents.new,
);

class RecentEvents extends Notifier<List<SyncEvent>> {
  @override
  List<SyncEvent> build() {
    ref.listen(eventStreamProvider, (_, next) {
      final event = next.value;
      if (event != null) state = [event, ...state].take(200).toList();
    });
    return const [];
  }

  void clear() => state = const [];
}

final engineLogLinesProvider = NotifierProvider<EngineLogLines, List<String>>(
  EngineLogLines.new,
);

class EngineLogLines extends Notifier<List<String>> {
  @override
  List<String> build() {
    ref.listen(engineLogProvider, (_, next) {
      final line = next.value;
      if (line != null) state = [...state, line].takeLast(500);
    });
    return const [];
  }

  void clear() => state = const [];
}

extension on List<String> {
  List<String> takeLast(int n) => length <= n ? this : sublist(length - n);
}

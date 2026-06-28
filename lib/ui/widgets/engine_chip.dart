import 'package:declar_ui/declar_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../engine/syncthing_supervisor.dart';
import '../../i18n/strings.g.dart';
import '../../state/engine_providers.dart';
import 'expressive.dart';

class EngineChip extends ConsumerWidget {
  const EngineChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state =
        ref.watch(engineStatusProvider).value?.state ?? EngineState.idle;
    final t = context.t.engine;

    final (label, icon, bg, fg) = switch (state) {
      EngineState.running => (
        t.running,
        Icons.check_circle_rounded,
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      EngineState.remote => (
        t.remote,
        Icons.cloud_done_rounded,
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      EngineState.starting => (
        t.starting,
        Icons.hourglass_top_rounded,
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      EngineState.error => (
        t.error,
        Icons.error_rounded,
        colors.errorContainer,
        colors.onErrorContainer,
      ),
      _ => (
        t.stopped,
        Icons.pause_circle_rounded,
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
      ),
    };

    return ExpressiveStatusPill(
      label: label,
      icon: icon,
      color: bg,
      foregroundColor: fg,
    );
  }
}

import 'package:declar_ui/declar_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../i18n/strings.g.dart';
import '../../state/activity_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/expressive.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final t = context.t.activity;
    final events = ref.watch(recentEventsProvider);
    final log = ref.watch(engineLogLinesProvider);

    return SafeArea(
      top: false,
      child: ExpressiveResponsiveCenter(
        maxWidth: 820,
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 14,
          children: [
            M3EToggleButtonGroup(
              actions: [
                M3EToggleButtonGroupAction(label: Text(t.events)),
                M3EToggleButtonGroupAction(label: Text(t.log)),
              ],
              type: .connected,
              size: .sm,
              style: .tonal,
              selectedIndex: _tab,
              onSelectedIndexChanged: (i) {
                if (i != null) setState(() => _tab = i);
              },
            ),
            Expanded(
              child: ExpressiveSwitcher(
                child: _tab == 0
                    ? _EventsList(key: const ValueKey('events'), events: events)
                    : _LogList(key: const ValueKey('log'), lines: log),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  const _EventsList({super.key, required this.events});

  final List events;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (events.isEmpty) {
      return EmptyState(
        icon: Icons.bolt_rounded,
        title: context.t.activity.empty,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: events.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final event = events[i];
        return ExpressivePanel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          radius: 20,
          child: Row(
            children: [
              ExpressiveIconContainer(
                icon: Icons.bolt_rounded,
                size: 38,
                radius: 12,
                color: colors.secondaryContainer,
                foregroundColor: colors.onSecondaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${event.type}',
                  maxLines: 1,
                ).size(14).weight(.w700),
              ),
              Text('#${event.id}').size(12).color(colors.onSurfaceVariant),
            ],
          ),
        );
      },
    );
  }
}

class _LogList extends StatelessWidget {
  const _LogList({super.key, required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (lines.isEmpty) {
      return EmptyState(
        icon: Icons.terminal_rounded,
        title: context.t.activity.empty,
      );
    }
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: M3EButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: lines.join('\n')));
              context.showSnackBar(context.t.common.copied);
            },
            icon: const Icon(Icons.copy_rounded),
            label: Text(context.t.activity.copyLog),
            style: .tonal,
            size: .sm,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(lines[i]).size(12).color(colors.onSurfaceVariant),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

Future<T?> showAdaptiveModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  final wide = MediaQuery.sizeOf(context).width >= 720;
  if (!wide) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(child: builder(context)),
    );
  }
  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 720),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: builder(context),
          ),
        ),
      ),
    ),
  );
}

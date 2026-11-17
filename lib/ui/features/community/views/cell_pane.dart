import 'package:flutter/material.dart';
import '../../../../l10n/locale.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../view_models/community_view_model.dart';

/// Scrolls only the task content while keeping its save action within reach.
/// The unbounded variant also supports embedded previews and larger layouts.
class CellPane extends StatelessWidget {
  const CellPane({
    super.key,
    required this.children,
    this.footer,
    this.onRefresh,
    this.model,
    this.storageKey = 'cell-pane',
  });
  final String storageKey;
  final CommunityViewModel? model;
  final List<Widget> children;
  final Widget? footer;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      Future<void> refresh() async {
        if (model == null ||
            model!.busy ||
            model!.plannerBusy ||
            model!.pickingPhoto) {
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        if (model!.dirty && !await confirmDiscard(context)) return;
        await model!.refresh();
      }

      final inlineFooter =
          constraints.hasBoundedHeight && constraints.maxHeight < 200;
      final content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (model?.busy == true) const LinearProgressIndicator(minHeight: 2),
          if (model?.error != null) ...[
            FeedbackPanel(
              model!.error!,
              error: true,
              action: TextButton(
                onPressed: refresh,
                child: Text(tr('Reintentar')),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (model?.notice != null) ...[
            FeedbackPanel(model!.notice!),
            const SizedBox(height: 16),
          ],
          ...children,
          if (inlineFooter && footer != null) ...[
            const SizedBox(height: 24),
            footer!,
          ],
        ],
      );
      if (!constraints.hasBoundedHeight) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            content,
            if (footer != null) ...[const SizedBox(height: 24), footer!],
          ],
        );
      }
      Widget scroll = ListView(
        key: PageStorageKey('$storageKey/${model?.cell?.id}/${model?.day}'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [content],
      );
      if (onRefresh != null || model != null) {
        scroll = RefreshIndicator(
          onRefresh: onRefresh ?? refresh,
          child: scroll,
        );
      }
      return Column(
        children: [
          Expanded(child: scroll),
          if (footer != null && !inlineFooter)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: .1),
                  ),
                ),
              ),
              child: footer,
            ),
        ],
      );
    },
  );
}

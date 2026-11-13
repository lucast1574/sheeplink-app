import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/personal_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../view_models/community_view_model.dart';

Future<void> showAnnouncementsSheet(
  BuildContext context,
  CommunityViewModel model,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: AppTheme.paper,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (context) => _AnnouncementsSheet(model: model),
);

class _AnnouncementsSheet extends StatefulWidget {
  const _AnnouncementsSheet({required this.model});
  final CommunityViewModel model;

  @override
  State<_AnnouncementsSheet> createState() => _AnnouncementsSheetState();
}

class _AnnouncementsSheetState extends State<_AnnouncementsSheet> {
  String? _openId;

  String _formatDate(String raw) {
    final parsed = DateTime.tryParse(raw)?.toLocal();
    if (parsed == null) return '';
    return DateFormat("d 'de' MMM", 'es').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.model,
      builder: (context, _) {
        final items = widget.model.announcements;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 16, 10),
                child: Row(
                  children: [
                    const AppIcon(Symbol.bell, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mensajes y avisos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.pop(context),
                      icon: const AppIcon(Symbol.close, size: 20),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No tienes avisos pendientes por ahora.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final unread = !item.sent && !item.read;
                          final expanded = _openId == item.id;
                          return _AnnouncementCard(
                            item: item,
                            unread: unread,
                            expanded: expanded,
                            dateLabel: _formatDate(item.createdAt),
                            onTap: () {
                              setState(() => _openId = expanded ? null : item.id);
                              if (unread) widget.model.markAnnouncementRead(item);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.item,
    required this.unread,
    required this.expanded,
    required this.dateLabel,
    required this.onTap,
  });

  final ChurchAnnouncement item;
  final bool unread, expanded;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (unread)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: AppTheme.forest,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (item.isPinned)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.leaf.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'Fijado',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.ink,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (dateLabel.isNotEmpty)
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.audienceLabel.isNotEmpty
                    ? '${item.senderName} · ${item.audienceLabel}'
                    : item.senderName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                item.body,
                maxLines: expanded ? null : 2,
                overflow: expanded ? null : TextOverflow.ellipsis,
              ),
              if (expanded && item.activityName != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.paper,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.activityName!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (item.activityStartDate != null)
                        Text(
                          [
                            item.activityStartDate!,
                            if ((item.activityTime ?? '').isNotEmpty)
                              item.activityTime!,
                            if ((item.activityLocation ?? '').isNotEmpty)
                              item.activityLocation!,
                          ].join(' · '),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

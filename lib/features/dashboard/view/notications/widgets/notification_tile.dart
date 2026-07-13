import 'package:expense_tracker/core/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnread = !notification.isRead;
    final typeColor = _typeColor(notification.type, colorScheme);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(
          Icons.delete_sweep_rounded,
          color: colorScheme.onErrorContainer,
          size: 26,
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isUnread
                ? colorScheme.primaryContainer.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread
                  ? colorScheme.primary.withValues(alpha: 0.25)
                  : colorScheme.outlineVariant.withValues(alpha: 0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isUnread ? onTap : null,
              child: Stack(
                children: [
                  // Left Accent Colored Bar Indicator
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: typeColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Glow Icon Badge Component
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                typeColor.withValues(alpha: 0.25),
                                typeColor.withValues(alpha: 0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: typeColor.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _typeIcon(notification.type),
                            color: typeColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Text Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: isUnread
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: colorScheme.onSurface,
                                        fontSize: 14.5,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Time Label
                                  Text(
                                    _formatTime(notification.createdAt.toDate()),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notification.body,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                                  fontSize: 13,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Tag & Unread Status Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Category/Type Tag Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: typeColor.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: typeColor.withValues(alpha: 0.15),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      _typeLabel(notification.type),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: typeColor,
                                      ),
                                    ),
                                  ),
                                  // Pulse Unread Indicator Dot / "New" Chip
                                  if (isUnread)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'NEW',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return Icons.warning_amber_rounded;
      case NotificationType.transaction:
        return Icons.receipt_long_rounded;
      case NotificationType.dailyReminder:
        return Icons.notifications_active_rounded;
      case NotificationType.fcm:
        return Icons.campaign_rounded;
      case NotificationType.other:
        return Icons.info_outline_rounded;
    }
  }

  Color _typeColor(NotificationType type, ColorScheme cs) {
    switch (type) {
      case NotificationType.budgetAlert:
        return Colors.amber.shade700;
      case NotificationType.transaction:
        return cs.primary;
      case NotificationType.dailyReminder:
        return Colors.indigo.shade600;
      case NotificationType.fcm:
        return Colors.teal.shade600;
      case NotificationType.other:
        return cs.secondary;
    }
  }

  String _typeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return 'Budget Alert';
      case NotificationType.transaction:
        return 'Transaction';
      case NotificationType.dailyReminder:
        return 'Daily Reminder';
      case NotificationType.fcm:
        return 'Announcement';
      case NotificationType.other:
        return 'General';
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

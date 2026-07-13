import 'package:expense_tracker/features/dashboard/view/notications/widgets/empty_state.dart';
import 'package:expense_tracker/features/dashboard/view/notications/widgets/notification_tile.dart';
import 'package:expense_tracker/features/dashboard/view/notifications/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ctrl = context.watch<NotificationController>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        title: Text(
          'Notifications',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (ctrl.hasUnread)
            IconButton(
              tooltip: 'Mark all read',
              onPressed: () => ctrl.markAllAsRead(),
              icon: Icon(
                Icons.done_all_rounded,
                color: colorScheme.primary,
              ),
            ),
          PopupMenuButton<_Action>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (action) {
              if (action == _Action.deleteAll) {
                _confirmDeleteAll(context, ctrl);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: _Action.deleteAll,
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Clear all', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ctrl.notifications.isEmpty
          ? const NotificationEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: ctrl.notifications.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 72,
                endIndent: 16,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                final notif = ctrl.notifications[index];
                return NotificationTile(
                  notification: notif,
                  onTap: () => ctrl.markAsRead(notif.id),
                  onDismiss: () => ctrl.deleteNotification(notif.id),
                );
              },
            ),
    );
  }

  Future<void> _confirmDeleteAll(
      BuildContext context, NotificationController ctrl) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
            'This will permanently delete all your notifications. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ctrl.deleteAll();
    }
  }
}

enum _Action { deleteAll }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/app_header.dart';
import 'package:reservation_workshop/modules/notifications/data/models/maintenance_notification_model.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_cubit.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_state.dart';

class MaintenanceNotificationsScreen extends StatefulWidget {
  const MaintenanceNotificationsScreen({super.key});

  @override
  State<MaintenanceNotificationsScreen> createState() => _MaintenanceNotificationsScreenState();
}

class _MaintenanceNotificationsScreenState extends State<MaintenanceNotificationsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MaintenanceNotificationsCubit>().refresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7FAFF), Color(0xFFF4F7FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: 'notifications.title'.tr(),
                onBack: () => Navigator.pop(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimarySoft2,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.brandPrimary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    tabs: [
                      Tab(text: 'notifications.unread'.tr()),
                      Tab(text: 'notifications.read'.tr()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<MaintenanceNotificationsCubit, MaintenanceNotificationsState>(
                  builder: (context, state) {
                    if (state is MaintenanceNotificationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MaintenanceNotificationsError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey7,
                            ),
                          ),
                        ),
                      );
                    }

                    final items = state is MaintenanceNotificationsSuccess ? state.notifications : const <MaintenanceNotificationModel>[];
                    final unread = items.where((n) => !n.isRead).toList();
                    final read = items.where((n) => n.isRead).toList();

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'notifications.empty'.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey7,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.grey7),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<MaintenanceNotificationsCubit>().markAllRead();
                                },
                                child: Text('notifications.mark_all_read'.tr()),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _NotificationsList(
                                items: unread,
                                emptyText: 'notifications.empty_unread'.tr(),
                                onMarkRead: (id) => context.read<MaintenanceNotificationsCubit>().markRead(notificationIds: [id]),
                              ),
                              _NotificationsList(
                                items: read,
                                emptyText: 'notifications.empty_read'.tr(),
                                onMarkRead: null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({
    required this.items,
    required this.emptyText,
    required this.onMarkRead,
  });

  final List<MaintenanceNotificationModel> items;
  final String emptyText;
  final void Function(String id)? onMarkRead;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.grey7,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return _NotificationTile(
          item: item,
          onTap: onMarkRead == null || item.isRead ? null : () => onMarkRead!(item.id),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final MaintenanceNotificationModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final payload = item.data;

    final title = (payload?.jobSheetNo?.trim().isNotEmpty == true)
        ? 'ورقة عمل: ${payload!.jobSheetNo}'
        : 'إشعار صيانة';

    final subtitle = (payload?.action?.trim().isNotEmpty == true) ? payload!.action! : item.type;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : const Color(0xFFF5F8FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isRead ? const Color(0xFFE6E8EC) : const Color(0xFFD9E6FF),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.isRead ? const Color(0xFFEFF1F5) : const Color(0xFFE6EEFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications,
                  color: item.isRead ? Colors.black54 : const Color(0xFF1D4ED8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.grey7),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.brandPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

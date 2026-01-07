import 'package:reservation_workshop/modules/notifications/data/models/maintenance_notification_model.dart';

abstract class MaintenanceNotificationsState {
  const MaintenanceNotificationsState();
}

class MaintenanceNotificationsInitial extends MaintenanceNotificationsState {
  const MaintenanceNotificationsInitial();
}

class MaintenanceNotificationsLoading extends MaintenanceNotificationsState {
  const MaintenanceNotificationsLoading();
}

class MaintenanceNotificationsSuccess extends MaintenanceNotificationsState {
  const MaintenanceNotificationsSuccess(this.notifications);

  final List<MaintenanceNotificationModel> notifications;

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  int get readCount => notifications.where((n) => n.isRead).length;
}

class MaintenanceNotificationsError extends MaintenanceNotificationsState {
  const MaintenanceNotificationsError(this.message);

  final String message;
}

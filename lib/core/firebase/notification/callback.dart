import "notification.dart" show RemoteMessage, AuthorizationStatus;

typedef NotificationNavigationCallback =
    void Function(Map<String, dynamic> data);

typedef BackgroundMsgCallback = void Function(RemoteMessage data);
typedef PermissionCallback = void Function(AuthorizationStatus status);

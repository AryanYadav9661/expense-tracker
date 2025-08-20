
import 'package:flutter/services.dart';

class NotificationBridge {
  static const MethodChannel _ch = MethodChannel('com.expensetracker/notifications');

  static void init(void Function(String text, String pkg) onNotification) {
    _ch.setMethodCallHandler((call) async {
      if (call.method == 'onNotification') {
        final args = Map<String, dynamic>.from(call.arguments);
        final text = args['text'] as String? ?? '';
        final pkg = args['package'] as String? ?? '';
        onNotification(text, pkg);
      }
    });
  }
}

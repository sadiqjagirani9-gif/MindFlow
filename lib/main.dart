import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/app/app.dart';
import 'package:mindflow/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.instance.initialize();
  } catch (_) {
    // Notifications are optional on desktop/web; the core app remains usable.
  }
  runApp(const ProviderScope(child: MindFlowApp()));
}

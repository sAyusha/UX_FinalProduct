// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/app.dart';
import 'core/network/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveService().init();
  await initializeDateFormatting('en_US', null).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}
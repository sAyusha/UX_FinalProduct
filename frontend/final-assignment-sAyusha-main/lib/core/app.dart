import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../config/router/app_route.dart';
import '../config/constants/size_config.dart';
import '../config/themes/model_theme.dart';
// import '../config/themes/size_config.dart';

// List<User> allUsers = [];

final themeProvider = ChangeNotifierProvider<ModelTheme>((ref) => ModelTheme());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // initialize sizeconfig
    SizeConfig.init(context);
    return KhaltiScope(
      publicKey: 'test_public_key_59f37294097b46608dc810d923003d0a',
      enabledDebugging: true,
      builder: (context, navKey) {
        return Consumer(builder: (context, ref, child) {
          final themeNotifier = ref.watch(themeProvider);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Artalyst',
            theme: themeNotifier.isDark
                ? ThemeData.dark()
                : AppTheme.getApplicationTheme(context),
            initialRoute: AppRoute.splashRoute,
            routes: AppRoute.getApplicationRoute(),
            navigatorKey: navKey,
            localizationsDelegates: const [KhaltiLocalizations.delegate],
          );
        });
      },
    );
  }
}

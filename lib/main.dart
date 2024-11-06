import 'package:feature/messagingService/MessagingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mamak/di/NetworkModule.dart';
import 'package:mamak/di/appModule.dart';
import 'package:mamak/firebase/PushNotificationImpl.dart';
import 'package:mamak/presentation/translation.dart';

import 'config/appData/appTheme/AppTheme.dart';
import 'config/appData/locales/AppDefaultLocale.dart';
import 'config/appData/route/AppRoute.dart';
import 'config/appData/route/AppRouteHelper.dart';
import 'presentation/viewModel/app/appViewModel.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  BaseLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Responsive Web App')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          return Center(
            child: Container(
              width: screenWidth < 600
                  ? screenWidth // Mobile: full width
                  : 414,
              child: child, // Use the provided screen content
            ),
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationImpl.invoke();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await AppModule.initModules();
  await NetworkModule.initNetworkModule();
  await AppViewModel.initInterceptors();
  Get.locale = const Locale('fa', 'IR');

  // await bootstrapEngine();
  // setPathUrlStrategy();
  runApp(BlocBuilder(
    bloc: AppViewModel.getInstance,
    builder: (context, state) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoute.splash,
      darkTheme: AppTheme.myTheme(),
      getPages: AppRouteHelper.router,
      title: 'Mamak',
      theme: AppTheme.myTheme(),
      locale: AppDefaultLocale.getAppLocale,
      supportedLocales: AppDefaultLocale.supportedLocale,
      localizationsDelegates: AppDefaultLocale.localizationDelegate,
      localeResolutionCallback: (_, __) => AppDefaultLocale.getAppLocale,
      builder: rootTransitionBuilder,
      scaffoldMessengerKey: GetIt.I.get<MessagingServiceImpl>().messageService,
      fallbackLocale: AppDefaultLocale.fallBackLocale,
      translations: GetIt.I.get<MamakTranslation>(),
    );
  }

  TransitionBuilder get rootTransitionBuilder =>
      (context, child) => Scaffold(body: child);
}

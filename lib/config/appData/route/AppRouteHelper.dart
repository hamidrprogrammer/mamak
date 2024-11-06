import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mamak/presentation/ui/Information/InformationUi.dart';
import 'package:mamak/presentation/ui/app/ShotViewrUi.dart';
import 'package:mamak/presentation/ui/category/CategoryDetailUI.dart';
import 'package:mamak/presentation/ui/child/AddChildUi.dart';
import 'package:mamak/presentation/ui/child/EditChildPage.dart';
import 'package:mamak/presentation/ui/child/MyChildrenScreen.dart';
import 'package:mamak/presentation/ui/child/TransactionsScreen.dart';
import 'package:mamak/presentation/ui/login/LoginUi.dart';
import 'package:mamak/presentation/ui/more/languages_ui.dart';
import 'package:mamak/presentation/ui/more/source_page.dart';
import 'package:mamak/presentation/ui/newHome/new_home_ui.dart';
import 'package:mamak/presentation/ui/package/PackageDetailUI.dart';
import 'package:mamak/presentation/ui/register/RegisterUi.dart';
import 'package:mamak/presentation/ui/root/MainPageUI.dart';
import 'package:mamak/presentation/ui/splash/SplashUi.dart';
import 'package:mamak/presentation/ui/subscription/SubscriptionUI.dart';
import 'package:mamak/presentation/ui/user/ChangePasswordUi.dart';
import 'package:mamak/presentation/ui/user/ForgetPasswordUi.dart';
import 'package:mamak/presentation/ui/user/RecoveryPasswordUi.dart';
import 'package:mamak/presentation/ui/user/VerificationUi.dart';
import 'package:mamak/presentation/ui/user/profile/CalendarScreen.dart';
import 'package:mamak/presentation/ui/user/profile/TmasNama.dart';
import 'package:mamak/presentation/ui/workBook/WorkBookDetailUi.dart';
import 'package:mamak/presentation/ui/workBook/WorkDetails.dart';
import 'package:mamak/presentation/ui/workShop/AssessmentsUi.dart';

import 'AppRoute.dart';

class AppRouteHelper {
  static List<GetPage> router = [
    GetPage(
      name: AppRoute.login,
      page: () => BaseLayout(child: const LoginUi()),
    ),
    GetPage(
      name: AppRoute.register,
      page: () => BaseLayout(child: const RegisterUi()),
    ),
    GetPage(
      name: AppRoute.subscription,
      page: () => BaseLayout(child: const SubscriptionUI()),
    ),
    GetPage(
      name: AppRoute.information,
      page: () => BaseLayout(child: const InformationUi()),
    ),
    GetPage(
      name: AppRoute.home,
      page: () => BaseLayout(child: const MainPageUI()),
    ),
    GetPage(
      name: AppRoute.root,
      page: () => BaseLayout(child: const MainPageUI()),
    ),
    GetPage(
      name: AppRoute.splash,
      page: () => const SplashUi(), // Splash screen might not need layout
    ),
    GetPage(
      name: AppRoute.verification,
      page: () => BaseLayout(child: const VerificationUi()),
    ),
    GetPage(
      name: AppRoute.packageDetail,
      page: () => BaseLayout(child: const PackageDetailUI()),
    ),
    GetPage(
      name: AppRoute.forgetPassword,
      page: () => BaseLayout(child: const ForgetPasswordUi()),
    ),
    GetPage(
      name: AppRoute.contactUsApp,
      page: () => BaseLayout(child: const ContactUsApp()),
    ),
    GetPage(
      name: AppRoute.changePassword,
      page: () => BaseLayout(child: const ChangePasswordUi()),
    ),
    GetPage(
      name: AppRoute.myChildren,
      page: () => BaseLayout(child: const MyChildrenScreen()),
    ),
    GetPage(
      name: AppRoute.eitChildPage,
      page: () => BaseLayout(child: const EditChildPage()),
    ),
    GetPage(
      name: AppRoute.calendarScreen,
      page: () => BaseLayout(child: const CalendarScreen()),
    ),
    GetPage(
      name: AppRoute.transactionsScreen,
      page: () => BaseLayout(child: const TransactionsScreen()),
    ),
    GetPage(
      name: AppRoute.recoveryPassword,
      page: () => BaseLayout(child: const RecoveryPasswordUi()),
    ),
    GetPage(
      name: AppRoute.workBookDetail,
      page: () => BaseLayout(child: const WorkBookDetailUi()),
    ),
    GetPage(
      name: AppRoute.assessments,
      page: () => BaseLayout(child: const AssessmentsUi()),
    ),
    GetPage(
      name: AppRoute.addChild,
      page: () => BaseLayout(child: const AddChildUi()),
    ),
    GetPage(
      name: AppRoute.workDetails,
      page: () => BaseLayout(child: const WorkDetails()),
    ),
    GetPage(
      name: AppRoute.categoryDetail,
      page: () => BaseLayout(child: const CategoryDetailUI()),
    ),
    GetPage(
      name: AppRoute.shotViewer,
      page: () => BaseLayout(child: const ShotViewerUi()),
    ),
    GetPage(
      name: AppRoute.newHome,
      page: () => BaseLayout(child: const NewHomeUi()),
    ),
    GetPage(
      name: AppRoute.sourceClick,
      page: () => BaseLayout(child: const SourceUi()),
    ),
    GetPage(
      name: AppRoute.languages,
      page: () => BaseLayout(child: const LanguagesUi()),
    ),
  ];
}

class BaseLayout extends StatelessWidget {
  final Widget child;

  BaseLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // For larger screens
          return Center(
            child: Container(
              width: 370,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

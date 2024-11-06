import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamak/config/uiCommon/WidgetSize.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/viewModel/update/UpdateViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => UpdateViewModel(AppState.idle),
      builder: (bloc, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            insetPadding: const EdgeInsets.all(WidgetSize.pagePaddingSize),
            child: Padding(
              padding: const EdgeInsets.all(WidgetSize.pagePaddingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'update_msg'.tr,
                    style: context.textTheme.titleMedium,
                  ),
                  20.dpv,
                  ElevatedButton(
                      onPressed: () {
                        _launchUrl(link);
                      },
                      child: Text('update'.tr)),
                  20.dpv,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _launchUrl(String link) async {
    return launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }
}

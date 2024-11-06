import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 8.dpeh,
      child: ElevatedButton(onPressed: () {}, child: Text('subscribe_buy'.tr)),
    );
  }
}

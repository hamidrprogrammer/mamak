import 'package:flutter/material.dart';
import 'package:mamak/presentation/ui/Home/HomeAppbar.dart';

class MamakScaffold extends StatelessWidget {
  const MamakScaffold({Key? key, required this.body}) : super(key: key);
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}

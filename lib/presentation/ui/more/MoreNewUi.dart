import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MamakScaffold.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/uiModel/more/MoreItemModel.dart';
import 'package:mamak/presentation/viewModel/more/MoreViwModel.dart';

class MoreHomeNewUi extends StatelessWidget {
  const MoreHomeNewUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => MoreViewModel(AppState.idle),
      builder: (bloc, state) {
        return MamakScaffold(
          body: Padding(
            padding: 16.dpe,
            child: GridView.builder(
              itemCount: bloc.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 100,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) =>
                  MoteItemUi(item: bloc.items[index]),
            ),
          ),
        );
      },
    );
  }
}

class MoteItemUi extends StatelessWidget {
  const MoteItemUi({Key? key, required this.item}) : super(key: key);
  final MoreItemModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onClick,
      child: Padding(
        padding: 8.dpe,
        child: Column(
          children: [Icon(item.iconData), 4.dpv, Text(item.name,textAlign: TextAlign.center,style: context.textTheme.bodySmall?.copyWith(fontSize: 10),)],
        ),
      ),
    );
  }
}

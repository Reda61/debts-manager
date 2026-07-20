import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class C_filterDebtsTypesBar extends StatelessWidget {
  final void Function(int)? onTap;
  const C_filterDebtsTypesBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.green[200],
        // border: Border.all(color: Colors.black),
      ),
      child: TabBar(
        onTap: onTap,
        labelStyle: Theme.of(context).textTheme.bodyMedium,

        indicatorPadding: EdgeInsets.symmetric(horizontal: -15, vertical: 4),

        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade900,
        tabs: [
          Tab(text: 'all'.tr()),
          Tab(text: 'i_get'.tr()),
          Tab(text: 'i_owe'.tr()),
        ],
      ),
    );
  }
}

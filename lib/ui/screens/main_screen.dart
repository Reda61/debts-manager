import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/sync_functions.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/sql_db.dart';
import 'package:expenses4/ui/widgets/app_widgets/c_drawer.dart';
import 'package:expenses4/ui/screens/debts/debts_screen.dart';
import 'package:expenses4/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class clsMainScreen extends StatefulWidget {
  int initialIndex;
  clsMainScreen({super.key, this.initialIndex = 0});

  @override
  State<clsMainScreen> createState() => _clsMainScreenState();
}

class _clsMainScreenState extends State<clsMainScreen> {
  final List<Widget> _homeScreenWidgets = [
    clsHomeScreen(), // Placeholder for Home content
    clsDebtsScreen(), // Placeholder for Debts content
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: clsAppDrawer(
        tapOnHome: (index) => setState(() {
          widget.initialIndex = index;
        }),
        tapOnSettings: () async {
          await Navigator.pushNamed(context, 'settingsScreen');
          setState(() {});
        },
      ),

      appBar: AppBar(
        title: Text(
          "app_name".tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                "addEditDebt",
                arguments: {"modeScreen": enMode.AddNew},
              );

              widget.initialIndex = widget.initialIndex == 0 ? 1 : 1;
              setState(() {});
            },

            color: Colors.green,
            iconSize: 38,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.initialIndex,
        onTap: (index) => setState(() => widget.initialIndex = index),
        selectedFontSize: 16,

        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'debts'.tr(),
          ),
        ],
      ),
      body: _homeScreenWidgets[widget.initialIndex],
    );

    // Positioned(
    //   bottom: 40,
    //   child: SizedBox(
    //     width: 60,
    //     height: 60,
    //     child: FloatingActionButton(
    //       onPressed: () async {
    //         Navigator.pushNamed(
    //           context,
    //           "addEditDebt",
    //           arguments: {"modeScreen": enMode.AddNew},
    //         );
    //         // if (widget.initialIndex == 0) widget.initialIndex = 1;
    //         // setState(() {});
    //       },
    //       child: Icon(Icons.add, size: 30, color: Colors.white),
    //       shape: CircleBorder(),
    //       backgroundColor: Colors.green[700],
    //     ),
    //   ),
    // ),
  }
}

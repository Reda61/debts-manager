import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/sync_functions.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/ui/widgets/debts/c_filter_debts_types_bar.dart';
import 'package:expenses4/ui/widgets/debts/c_debt_card.dart';
import 'package:expenses4/ui/widgets/app_widgets/custom_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clsDebtsScreen extends StatefulWidget {
  const clsDebtsScreen({super.key});

  @override
  State<clsDebtsScreen> createState() => _clsDebtsScreenState();
}

class _clsDebtsScreenState extends State<clsDebtsScreen> {
  // List<Map> _debtsList = [];
  int tabIndex = 0;
  List debtsListSelected = [];
  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    Future.microtask(() async {
      if (mounted) {
        await context.read<clsDebtProvider>().getAllDebts();
      }
      // print(" --------------------------------=============== Debts + result");
      // print(context.read<clsDebtProvider>().Debts);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'debts'.tr(),
              style: TextStyle(color: Colors.green[500]),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(130),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 15,
                      right: 15,
                      bottom: 15,
                    ),
                    child: clsCustomSearchBar(
                      onChanged: (val) {
                        context.read<clsDebtProvider>().searchDebts(val);
                      },
                      textController: searchController,
                    ),
                  ),
                  C_filterDebtsTypesBar(
                    onTap: (index) {
                      tabIndex = index;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),

          floatingActionButton: SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              onPressed: () async {
                context.read<clsDebtProvider>().searchDebts("");
                searchController.clear();
                await Navigator.pushNamed(
                  context,
                  "addEditDebt",
                  arguments: {"modeScreen": enMode.AddNew},
                );
              },

              shape: CircleBorder(),
              backgroundColor: Colors.green[700],
              child: Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Consumer<clsDebtProvider>(
              builder: (context, proDebts, _) {
                if (!proDebts.Debts.isEmpty) {
                  print("Debts here -----------------------------------------");
                  print(proDebts.Debts);
                }
                if (proDebts.Debts.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: 160),
                      Center(
                        child: Text(
                          'no_debts'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(color: Colors.amber),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: proDebts.selectedDebtsTypeList.isEmpty
                      ? 0
                      : proDebts.selectedDebtsTypeList[tabIndex].length,
                  itemBuilder: (context, index) {
                    if (proDebts.selectedDebtsTypeList.isEmpty) {
                      return Center(
                        child: Text(
                          'no_debts'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    if (proDebts.selectedDebtsTypeList[tabIndex].isEmpty) {
                      return Center(
                        child: Text(
                          'no_debt_yet'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return clsDebtCard(
                      personName: proDebts
                          .selectedDebtsTypeList[tabIndex][index]['fullname'],
                      amount: proDebts
                          .selectedDebtsTypeList[tabIndex][index]['amount'],
                      debtType:
                          proDebts.selectedDebtsTypeList[tabIndex][index]['isPaidToMe'] ==
                              1
                          ? enDebtType.Iget
                          : enDebtType.Ipay,
                      personImageUrl: 'i',
                      // personImageUrl: allDebts[index]['imagepath'],
                      date: proDebts
                          .selectedDebtsTypeList[tabIndex][index]['date'],
                      isPaid:
                          proDebts
                              .selectedDebtsTypeList[tabIndex][index]['isSettled'] ==
                          1,
                      paidAmount: proDebts
                          .selectedDebtsTypeList[tabIndex][index]['paidAmount'],
                      debtID:
                          proDebts.selectedDebtsTypeList[tabIndex][index]['id'],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

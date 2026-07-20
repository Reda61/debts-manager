import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ClsPopupMenuButtonOfDebt extends StatelessWidget {
  final String debtID;
  final Function onEdit;
  final Function onDelete;
  final Function onDeptPaid;
  ClsPopupMenuButtonOfDebt({
    super.key,
    required this.debtID,
    required this.onEdit,
    required this.onDelete,
    required this.onDeptPaid,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Text(
            'edit'.tr(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(
            'delete'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.red),
          ),
        ),
        PopupMenuItem(
          value: 'DebtPaid',
          child: Text(
            'debt_paid'.tr(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
          ),
        ),
      ],

      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            // Navigator.pushNamed(
            //   context,
            //   'addEditDebt',
            //   arguments: {'modeScreen': enMode.Updated, 'debtID': debtID},
            // );
            break;

          case 'delete':
            onDelete();
            // clsAppDialog.showDeleteConfirm(
            //   context,
            //   onConfirm: () async {
            //     bool isDeleted = await context.read<clsDebtProvider>().delete(
            //       debtID,
            //     );
            //     if (!isDeleted) {
            //       clsAppSnackBar.showError(context, "something Wrong");
            //     }
            //   },
            // );

            break;

          case 'DebtPaid':
            onDeptPaid();
            // clsAppDialog.showSettleConfirm(
            //   context,
            //   onConfirm: () async {
            //     bool isSettled = await context.read<clsDebtProvider>().settle(
            //       debtID,
            //     );
            //     if (!isSettled) {
            //       clsAppSnackBar.showError(
            //         context,
            //         "This operation was rejected",
            //       );
            //     }
            //   },
            // );

            break;

          default:
        }
      },
    );
  }
}

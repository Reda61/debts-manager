import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/debts_data.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/remote/api_service/debts_api_service.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';

class ClsDebtsUploadService {
  static Future<bool> uploadDebtsData(int userID) async {
    List<Map> unsynced = await clsDebts_data.getAllUnsyncedDebts();

    print("-------------------_upload Debts Data----------------------------");
    for (var unSy in unsynced) {
      print(unSy);
      print("--------------------------------------------------------");
    }

    if (unsynced.isEmpty) return true;

    for (var debt in unsynced) {
      clsDebt obDebt = clsDebtProvider.getStandardDebtFromMap(debt);
      enStatusResponse statusRespo = await ClsDebtsApiService.postDebt(
        obDebt,
        userID,
      );

      if (statusRespo == enStatusResponse.Ok) {
        await clsDebts_data.markForSync(obDebt.id!);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  static Future<bool> deleteDebtsData(int userID) async {
    List<Map> deleted = await clsDebts_data.getDeletedDebts();
    if (deleted.isEmpty) return true;

    for (Map object in deleted) {
      enStatusResponse statusResponse = await ClsDebtsApiService.deleteDebts(
        object['id'],
        userID,
      );

      if (statusResponse == enStatusResponse.Ok) {
        print("Ok************************************* Debts Deleted");
        await clsDebts_data.delete(object['id']);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }
}

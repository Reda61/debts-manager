import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/transactions_data.dart';
import 'package:expenses4/data/models/transaction.dart';
import 'package:expenses4/data/remote/api_service/transactions_api_service.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';

class ClsTransactionsUploadService {
  static Future<bool> uploadTransacionsData(int userID) async {
    List<Map> unsynced = await clsTransactions_data.getUnsyncedTransactions();

    print("-------------------_sync transactions Data------------------");
    for (var unSy in unsynced) {
      print(unSy);
      print("--------------------------------------------------------");
    }
    if (unsynced.isEmpty) return true;

    for (var transacion in unsynced) {
      ClsTransaction obTransaction =
          ClsTransactionProvider.getStandardTransactionFromMap(transacion);

      enStatusResponse statusRespo =
          await ClsTransactionsApiService.postTransacion(obTransaction, userID);
      if (statusRespo == enStatusResponse.Ok) {
        await clsTransactions_data.markForSync(obTransaction.id!);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  static Future<bool> deleteTransactionsData(int userID) async {
    List<Map> deleted = await clsTransactions_data.getIDsDeletedTransactions();
    if (deleted.isEmpty) return true;

    for (Map trans in deleted) {
      enStatusResponse statusResponse =
          await ClsTransactionsApiService.deleteTransactions(
            trans['id'].toString(),
            userID,
          );

      if (statusResponse == enStatusResponse.Ok) {
        print("Ok************************************* Payments Deleted");
        await clsTransactions_data.delete(trans['id']);
        return true;
      } else {
        return false;
      }
    }

    return true;
  }
}

import 'package:expenses4/data/local/local_data_access/transactions_data.dart';
import 'package:expenses4/data/models/api_response.dart';
import 'package:expenses4/data/remote/api_service/transactions_api_service.dart';

class ClsTransactionsDownloadService {
  static Future<bool> downloadTransactionsData(int userID) async {
    ClsApiResponse responseApi =
        await ClsTransactionsApiService.getAllTransacions(userID);

    if (!responseApi.isSuccess) return false;

    List transactions = responseApi.data;

    for (var transaction in transactions) {
      final exists = await clsTransactions_data.isExist(
        transaction['id'].toString(),
      );

      if (exists) {
        await clsTransactions_data.update(
          transaction['id'],
          (transaction['amount'] as num).toDouble(),
          transaction['debtID'],
          transaction['date'],
          isSynced: true,
        );
      } else {
        await clsTransactions_data.insert(
          id: transaction['id'],
          amount: (transaction['amount'] as num).toDouble(),
          debtID: transaction['debtID'],
          paymentID: transaction['paymentID'],
          date: transaction['date'],
          updateAt: transaction['updateAt'],
          isSynced: true,
        );
      }
    }
    return true;
  }
}

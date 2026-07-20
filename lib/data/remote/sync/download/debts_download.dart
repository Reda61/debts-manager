import 'package:expenses4/data/local/local_data_access/debts_data.dart';
import 'package:expenses4/data/models/api_response.dart';
import 'package:expenses4/data/remote/api_service/debts_api_service.dart';

class ClsDebtsDownloadService {
  static Future<bool> downloadDebtsData(int userID) async {
    ClsApiResponse responseApi = await ClsDebtsApiService.getAllDebts(userID);

    if (!responseApi.isSuccess) return false;

    List debts = responseApi.data;

    for (var debt in debts) {
      if (await clsDebts_data.isExist(debt['id'])) {
        await clsDebts_data.update(
          debt['id'],
          debt['personID'],
          (debt['amount'] as num).toDouble(),
          debt['paidAmount'],
          debt['isPaidToMe'],
          debt['isSettled'],
          debt['date'],
          debt['note'],
          isSynced: true,
        );

        continue;
      }

      await clsDebts_data.insert(
        id: debt['id'],
        personID: debt['personID'],
        amount: (debt['amount'] as num).toDouble(),
        paidAmount: debt['paidAmount'],
        isPaidToMe: debt['isPaidToMe'],
        isSettled: debt['isSettled'],
        date: debt['date'],
        note: debt['note'],
        updateAt: debt['updateAt'],
        isSynced: true,
      );
    }

    return true;
  }
}

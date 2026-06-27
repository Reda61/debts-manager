import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/models/api_response.dart';
import 'package:expenses4/data/remote/api_service/payments_api_service.dart';

class ClsPaymentsDownloadService {
  static Future<bool> downloadPaymentsData(int userID) async {
    ClsApiResponse responseApi = await ClsPaymentsApiService.getAllPayments(
      userID,
    );

    if (!responseApi.isSuccess) return false;
    List payments = responseApi.data;

    for (var payment in payments) {
      if (await clsPayments_data.isExist(payment['id'])) {
        await clsPayments_data.update(
          payment['id'],
          (payment['amount'] as num).toDouble(),
          payment['debtID'],
          payment['date'],
          isSynced: true,
        );

        continue;
      }

      await clsPayments_data.insert(
        paymentID: payment['id'],
        amount: (payment['amount'] as num).toDouble(),
        debtID: payment['debtID'],
        date: payment['date'],
        updateAt: payment['updateAt'],
        isSynced: true,
      );
    }
    return true;
  }
}

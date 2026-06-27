import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/models/Payment.dart';
import 'package:expenses4/data/remote/api_service/payments_api_service.dart';
import 'package:expenses4/logic/providers/payment_provider.dart';

class ClsPaymentsUploadService {
  static Future<bool> uploadPaymentsData(int userID) async {
    List<Map> unsynced = await clsPayments_data.getUnsyncedPayments();

    print("-------------------upload Payments Data------------------");
    for (var unSy in unsynced) {
      print(unSy);
      print("--------------------------------------------------------");
    }
    if (unsynced.isEmpty) return true;

    for (var payment in unsynced) {
      clsPayment obPayment = clsPaymentProvider.getStandardPaymentFromMap(
        payment,
      );

      enStatusResponse statusRespo = await ClsPaymentsApiService.postPayment(
        obPayment,
        userID,
      );

      if (statusRespo == enStatusResponse.Ok) {
        await clsPayments_data.markForSync(obPayment.id!);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  static Future<bool> deletePaymentsData(int userID) async {
    List<Map> deleted = await clsPayments_data.getIDsDeletedPayments();
    if (deleted.isEmpty) return true;

    for (Map object in deleted) {
      enStatusResponse statusResponse =
          await ClsPaymentsApiService.deletePayments(object['id'], userID);

      if (statusResponse == enStatusResponse.Ok) {
        print("Ok************************************* Payments Deleted");
        await clsPayments_data.delete(object['id']);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }
}

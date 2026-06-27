import 'package:expenses4/data/remote/sync/download/debts_download.dart';
import 'package:expenses4/data/remote/sync/download/payments_download.dart';
import 'package:expenses4/data/remote/sync/download/people_download.dart';
import 'package:expenses4/data/remote/sync/download/transactions_download.dart';
import 'package:expenses4/data/remote/sync/upload/debts_upload.dart';
import 'package:expenses4/data/remote/sync/upload/payments_upload.dart';
import 'package:expenses4/data/remote/sync/upload/people_upload.dart';
import 'package:expenses4/data/remote/sync/upload/transactions_upload.dart';

class ClsSyncService {
  //Delete Server Data
  static Future<bool> deleteAllData(int userID) async {
    bool isDeleted = await ClsTransactionsUploadService.deleteTransactionsData(
      userID,
    );
    if (!isDeleted) return false;

    isDeleted = await ClsPaymentsUploadService.deletePaymentsData(userID);
    if (!isDeleted) return false;

    isDeleted = await ClsDebtsUploadService.deleteDebtsData(userID);
    if (!isDeleted) return false;

    isDeleted = await ClsPeopleUploadService.deletePeopleData(userID);
    if (!isDeleted) return false;

    return true;
  }

  //upload Data
  static Future<bool> uploadAllData(int userID) async {
    bool isSynced = await ClsPeopleUploadService.uploadPeopleData(userID);
    if (!isSynced) return false;

    isSynced = await ClsDebtsUploadService.uploadDebtsData(userID);
    if (!isSynced) return false;

    isSynced = await ClsPaymentsUploadService.uploadPaymentsData(userID);
    if (!isSynced) return false;

    isSynced = await ClsTransactionsUploadService.uploadTransacionsData(userID);
    if (!isSynced) return false;

    return true;
  }

  //Download Data
  static Future<bool> downloadAllData(int userID) async {
    bool isRestored = await ClsPeopleDownloadService.downloadPeopleData(userID);
    if (!isRestored) return false;

    isRestored = await ClsDebtsDownloadService.downloadDebtsData(userID);
    if (!isRestored) return false;

    isRestored = await ClsPaymentsDownloadService.downloadPaymentsData(userID);
    if (!isRestored) return false;

    isRestored = await ClsTransactionsDownloadService.downloadTransactionsData(
      userID,
    );
    if (!isRestored) return false;

    return true;
  }
}

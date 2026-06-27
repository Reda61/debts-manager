import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/people_data.dart';
import 'package:expenses4/data/models/person.dart';
import 'package:expenses4/data/remote/api_service/people_api_service.dart';
import 'package:expenses4/logic/providers/person_provider.dart';

class ClsPeopleUploadService {
  static Future<bool> uploadPeopleData(int userID) async {
    List<Map> unsynced = await clsPeople_data.getAllUnsyncedPeople();

    print("-------------------upload People Data------------------");
    for (var unSy in unsynced) {
      print(unSy);
      print("--------------------------------------------------------");
    }
    if (unsynced.isEmpty) return true;

    for (var person in unsynced) {
      clsPerson obPerson = clsPersonProvider.getStandardPersonfromMap(person);
      enStatusResponse statusRespo = await ClsPeopleApiService.postPerson(
        obPerson,
        userID,
      );

      if (statusRespo == enStatusResponse.Ok) {
        await clsPeople_data.markForSync(obPerson.id!);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  static Future<bool> deletePeopleData(int userID) async {
    List<Map> deleted = await clsPeople_data.getDeletedPeople();
    if (deleted.isEmpty) return true;

    for (Map object in deleted) {
      enStatusResponse statusResponse = await ClsPeopleApiService.deletePerson(
        object['id'],
        userID,
      );

      if (statusResponse == enStatusResponse.Ok) {
        print("Ok************************************* People_data Deleted");
        await clsPeople_data.delete(object['id']);
        return true;
      } else {
        return false;
      }
    }
    return true;
  }
}

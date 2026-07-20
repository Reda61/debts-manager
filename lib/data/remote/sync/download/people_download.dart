import 'package:expenses4/data/local/local_data_access/people_data.dart';
import 'package:expenses4/data/models/api_response.dart';
import 'package:expenses4/data/remote/api_service/people_api_service.dart';

class ClsPeopleDownloadService {
  static Future<bool> downloadPeopleData(int userID) async {
    // List people = await ClsPeopleApiService.getAllPeople(userID);
    ClsApiResponse responseApi = await ClsPeopleApiService.getAllPeople(userID);
    if (!responseApi.isSuccess) return false;

    List people = responseApi.data;

    if (people.isEmpty) return true;
    for (var person in people) {
      if (await clsPeople_data.isExist(person['id'])) {
        await clsPeople_data.update(
          person['id'],
          person['fullname'],
          person['phone'],
          person['imagepath'],
          isSynced: true,
        );

        continue;
      }
      await clsPeople_data.insert(
        id: person['id'],
        fullname: person['fullname'],
        phone: person['phone'],
        imagepath: person['imagepath'],
        updateAt: person['updateAt'],

        isSynced: true,
      );
    }

    return true;
  }
}

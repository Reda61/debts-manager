import 'package:expenses4/core/my_own_enums/enums.dart';

class clsPerson {
  String? id;
  late String fullname;
  String? phone;
  String? imagepath;
  int isSynced = 0;
  int isDeleted = 0;
  String? updateAt;

  enMode mode = enMode.AddNew;

  clsPerson.empty() {
    id = null;
    fullname = '';
    phone = null;
    imagepath = null;

    mode = enMode.AddNew;
  }

  clsPerson({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.imagepath,
    required this.updateAt,
  }) {
    mode = enMode.Updated;
  }
}

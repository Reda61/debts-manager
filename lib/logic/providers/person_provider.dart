import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/people_data.dart';
import 'package:expenses4/data/models/person.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class clsPersonProvider extends ChangeNotifier {
  clsPerson _person = clsPerson.empty();

  clsPerson get person {
    return _person;
  }

  clsPerson setEmptyPerson() {
    _person = clsPerson.empty();
    return _person;
  }

  clsPerson _getfromMap(Map map) {
    return clsPerson(
      id: map['id'],
      fullname: map['fullname'],
      phone: map['phone'],
      imagepath: map['imagepath'],
      updateAt: map['updateAt'],
    );
  }

  static clsPerson getStandardPersonfromMap(Map map) {
    return clsPerson(
      id: map['id'],
      fullname: map['fullname'],
      phone: map['phone'],
      imagepath: map['imagepath'],
      updateAt: map['updateAt'],
    );
  }

  Future<List<Map<dynamic, dynamic>>> getAllPeople() async {
    return await clsPeople_data.getAllPeople();
  }

  void setPersonInfo(clsPerson person) {
    _person = person;
  }

  Future<clsPerson?> FindByID(String personID) async {
    Map<dynamic, dynamic>? data = await clsPeople_data.FindByID(personID);

    return data == null ? null : await _getfromMap(data);
  }

  Future<String> _AddNew() async {
    String newID = const Uuid().v4();
    int result = await clsPeople_data.insert(
      id: newID,
      fullname: _person.fullname, // here String id return
      phone: _person.phone,
      //  imagepath:  _person.imagepath,
    );
    if (result > 0) {
      _person.id = newID;
      return newID;
    }

    return "-1";
  }

  Future<String> _update() async {
    int result = await clsPeople_data.update(
      _person.id!,
      _person.fullname,
      _person.phone,
      _person.imagepath,
    );

    if (result > 0) return _person.id!;

    return "-1";
  }

  Future<String> save() async {
    if (_person.mode == enMode.AddNew) {
      String newID = await _AddNew();
      if (newID != "-1") {
        _person.mode = enMode.Updated;
        return newID;
      }
      return newID;
    } else {
      return await _update();
    }
  }

  Future<bool> delete(String personID) async {
    return await clsPeople_data.delete(personID) > 0;
  }

  Future<bool> setDelete(String personID) async {
    return await clsPeople_data.markForDelete(personID) > 0;
  }
}

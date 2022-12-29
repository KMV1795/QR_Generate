import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? phoneNumber;


  UserModel(
      this.id,
      this.phoneNumber,

      );

  UserModel.fromMap(DocumentSnapshot data) {
    id = data.id;
    phoneNumber = data["phoneNumber"];

  }
}
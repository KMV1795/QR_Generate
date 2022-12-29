import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDetailsModel {
  String? loginDate;
  String? loginTime;
  String? ipAddress;
  String? currentAddress;
  String? randomNumber;
  String? qrImage;

  LoginDetailsModel(
      this.loginDate,
      this.loginTime,
      this.ipAddress,
      this.currentAddress,
      this.randomNumber,
      this.qrImage,
      );

  LoginDetailsModel.fromMap(DocumentSnapshot data) {
    loginDate = data["loginDate"];
    loginTime = data["loginTime"];
    ipAddress = data["ipAddress"];
    currentAddress = data["currentAddress"];
    randomNumber = data["randomNumber"];
    qrImage = data["qrImage"];
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/LoginDetailsModel.dart';
import '../model/UserModel.dart';
import '../view/login_page.dart';
import '../widget/dialog.dart';

class LoginDetailsController extends GetxController{

  static LoginDetailsController instance =Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference loginReference = FirebaseFirestore.instance.collection("LoginDetails");
  RxList<LoginDetailsModel> loginDetailsList = RxList<LoginDetailsModel>([]);
  late LoginDetailsModel loginDetailsModel;

  CollectionReference userReference = FirebaseFirestore.instance.collection("User");
  RxList<UserModel> userList = RxList<UserModel>([]);
  late UserModel userModel;

  Stream<List<LoginDetailsModel>> getLoginDetails() =>
      loginReference.snapshots().map((snapshot) =>
          snapshot.docs.map((item) => LoginDetailsModel.fromMap(item)).toList());

  Stream<List<UserModel>> getUser() =>
      userReference.snapshots().map((snapshot) =>
          snapshot.docs.map((item) => UserModel.fromMap(item)).toList());

  var foundSearch = List.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    userList.bindStream(getUser());
    loginDetailsList.bindStream(getLoginDetails());
    foundSearch.value = loginDetailsList;
  }

  @override
  void onClose() {
    super.dispose();
  }


  Future addLoginDetails(
  String loginDate,
  String yesterdayDate,
  String loginTime,
  String ipAddress,
  String currentAddress,
  String randomNumber,
  String qrImage,
      ) async {
    loginReference.add({
      'loginDate': loginDate,
      'yesterdayDate':yesterdayDate,
      'loginTime': loginTime,
      'ipAddress':ipAddress,
      'currentAddress': currentAddress,
      'randomNumber': randomNumber,
      'qrImage': qrImage,
    }).whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "LoginDetails Added Successfully",
          message: "",
          backgroundColor: Colors.white);
    }).catchError((e) {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.redAccent);
    });
  }




  void searchToday (String query){
    loginReference.where('yesterdayDate',isEqualTo: query).get().then((value) => foundSearch.value = value.docs);
  }


  void logOut() async {
    await auth.signOut().then((value) => Get.offAll(() => const LoginPage()));
  }





}
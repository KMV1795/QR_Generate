import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_demo/view/last_login_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math';
import '../controller/login_details_controller.dart';

class DashBoardPage extends StatefulWidget {
  final String loginDate;
  final String yesterdayDate;
  final String loginTime;
  final String locationAddress;
  final String ipAddress;

  const DashBoardPage({
    Key? key,
    required this.loginDate,
    required this.yesterdayDate,
    required this.loginTime,
    required this.locationAddress,
    required this.ipAddress,
  }) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {

  final LoginDetailsController instance = Get.find();

  Future<Image>? image;

  Random random = Random();
  int number = 0;
  String randomNumberData = "";
  String appDocPath = "";

  late String loginDate;
  late String yesterdayDate;
  late String loginTime;
  late String locationAddress;
  late String ipAddress;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    number = random.nextInt(100);
    randomNumberData = number.toString();
    loginDate = widget.loginDate;
    yesterdayDate = widget.yesterdayDate;
    loginTime = widget.loginTime;
    ipAddress = widget.ipAddress;
    locationAddress = widget.locationAddress;
    if (kDebugMode) {
      print(
          "number---$number $loginDate $yesterdayDate $loginTime $ipAddress $locationAddress");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> get imagePath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
    return '$appDocPath/qr.png';
  }

  Future<Image> _loadImage() async {
    return await imagePath.then((imagePath) => Image.asset(imagePath));
  }

  Future<void> captureAndSaveQRCode() async {
    final imageDirectory = await imagePath;

    screenshotController.captureAndSave(imageDirectory);
    setState(() {
      image = _loadImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -30,
            child: Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.all(Radius.circular(200)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: (){
                instance.logOut();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 10),
                child: Text("LOGOUT",style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 08),
            // padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Screenshot(
                          controller: screenshotController,
                          child: QrImage(
                            data: randomNumberData,
                            gapless: true,
                            size: 250,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Generated Number",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    randomNumberData,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(1.0, 1.0),
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Center(
                              child: Text(
                            "Last login at today, $loginTime",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          )),
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                        instance.addLoginDetails(loginDate, yesterdayDate,loginTime, ipAddress,
                          locationAddress, randomNumberData, '');
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => LastLoginPage(loginDate: loginDate, yesterdayDate: yesterdayDate,)));
                    },
                    child: Center(
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  offset: const Offset(1.0, 1.0),
                                ),
                              ]),
                          child: const Center(
                              child: Text(
                            "SAVE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
            child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(05),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.lightBlue,
                        offset: Offset(1.0, 1.0),
                      ),
                    ]),
                child: const Center(
                    child: Text(
                  "PLUGIN",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ))),
          ),
        ],
      ),
    );
  }

  getApplicationDocumentsDirectory() {}
}

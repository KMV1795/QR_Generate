import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_demo/view/plugin_page.dart';
import 'package:intl/intl.dart';
import '../controller/phone_auth_controller.dart';
import 'package:dart_ipify/dart_ipify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool canShow = false;
  var result;

  String loginDate = "";
  String yesterdayDate = "";
  String loginTime = "";
  String ipAddress = "";
  Position? currentPosition;
  String currentAddress ="";

  Future<void> initPlatformState() async {
    String ip;
    try {
      ip = await Ipify.ipv64();
    } on PlatformException {
      ip = 'Failed to get ipAddress.';
    }
    if (!mounted) return;
    setState(() {
      ipAddress = ip;
    });
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        if (kDebugMode) {
          print(position.latitude);
          print(position.longitude);
        }
        getAddressFromLatLng();
      });
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentAddress = "${place.subLocality}";
        if (kDebugMode) {
          print(currentAddress);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getCurrentLocation();
    if (kDebugMode) {
      print("details------$yesterdayDate $loginDate $loginTime $ipAddress $currentAddress");
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
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
          Container(
            height: MediaQuery.of(context).size.height,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 08),
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 80, bottom: 50),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                boxShadow:  const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: phoneNumberController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.indigo,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  canShow ?
                  const Text(
                    "OTP",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ) : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  canShow ?
                  TextField(
                    controller: otpController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.indigo,
                          width: 0.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.indigo,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ) : Container(),
                  const SizedBox(
                    height: 80,
                  ),
                  !canShow ? buildSendOTPBtn("Send OTP") : submitBtn("LOGIN"),
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
                  "LOGIN",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ))),
          ),
        ],
      ),
    );
  }


  buildSendOTPBtn(String text) => Center(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.9),
         ),
      onPressed: () async {
        setState(() {
          canShow = !canShow;
        });
        result = await FirebaseAuthentication().sendOTP(phoneNumberController.text);
      },
      child: Text(text, style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700)),
    ),
  );


  Widget submitBtn(String text) => Center(
    child: SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.9),
        ),
        onPressed: () {
          loginDate = DateFormat('MMMM,dd,yyyy').format(DateTime.now());
          yesterdayDate = DateFormat('MMMM,dd,yyyy').format(DateTime.now().subtract(const Duration(days:1)));
          loginTime = DateFormat('hh:mm:ss a').format(DateTime.now());
          initPlatformState();
          getCurrentLocation();
          if (kDebugMode) {
            print("details------$yesterdayDate $loginDate $loginTime $ipAddress $currentAddress");
          }
         // FirebaseAuthentication().authenticatePhoneNumber(result, otpController.text);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DashBoardPage(
                loginDate: loginDate,
                yesterdayDate: yesterdayDate,
                loginTime: loginTime,
                ipAddress: ipAddress,
                locationAddress: currentAddress,
              )));
        },
        child: Text(text, style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700)),
      ),
    ),
  );

}

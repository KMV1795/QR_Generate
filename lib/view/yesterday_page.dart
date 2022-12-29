import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controller/login_details_controller.dart';
import '../model/LoginDetailsModel.dart';

class YesterdayPageView extends GetView<LoginDetailsController> {

  final String yesterdayDate;

  YesterdayPageView(this.yesterdayDate, {Key? key}) : super(key: key);

  final LoginDetailsController instance = Get.find();

  void initState(){
    instance.searchToday(yesterdayDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Obx(() {
        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: instance.foundSearch.length,
            itemBuilder: (BuildContext context, int index) {
              final LoginDetailsModel data = instance.foundSearch[index];
              return Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: Card(
                  color: Colors.black12.withOpacity(0.4),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.loginTime.toString(), style: const TextStyle(
                            color: Colors.white, fontSize: 18),),
                        Text("IP: ${data.ipAddress.toString()}", style: const TextStyle(
                            color: Colors.white, fontSize: 18),),
                        Text("${data.currentAddress.toString()} No Location", style: const TextStyle(
                            color: Colors.white, fontSize: 18),),
                      ],
                    ),
                    trailing: SizedBox(
                      height: 100,
                      width: 100,
                      child: QrImage(
                        data: data.randomNumber.toString(),
                        gapless: true,
                        size: 300,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

}


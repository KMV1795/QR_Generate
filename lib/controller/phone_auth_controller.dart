import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class FirebaseAuthentication{

  FirebaseAuth auth = FirebaseAuth.instance;

  String phoneNumber ="";


  sendOTP(String phoneNumber) async{
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+91 $phoneNumber');
    PrintMessage("OTP Sent to phoneNumber");
    return confirmationResult;
  }

  authenticatePhoneNumber(ConfirmationResult confirmationResult, String otp) async {
    UserCredential userCredential = await confirmationResult.confirm(otp);
    userCredential.additionalUserInfo!.isNewUser ? PrintMessage("Successful Authentication"):PrintMessage("User Already exists");
  }

  PrintMessage(String msg){
    debugPrint(msg);
  }

  authenticate(String phoneNumber)async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // For andriod only automatic handling of the SMS code
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        // SMS Code sent show a dialogue to enter the code.
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

}




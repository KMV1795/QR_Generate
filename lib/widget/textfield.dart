import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTextField(
    String labelText,
    TextEditingController textEditingController,
    IconData prefixIcons,
    BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(10.00),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: TextFormField(
          obscureText: labelText == "OTP" ? true : false,
          controller: textEditingController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5.5),
            ),
            hintText: labelText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.blue[50],
          ),
        ),
      ),
    );
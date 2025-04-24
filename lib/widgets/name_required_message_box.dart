import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/colors.dart';
import '../screens/home_screen.dart'; // <- Update to your actual path

class NameInputDialog {
  static Future<void> show(BuildContext context, {String initialName = ''}) async {
    TextEditingController nameController = TextEditingController(text: initialName);
    final box = GetStorage();
    Completer<void> completer = Completer<void>();

    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: true,
      headerAnimationLoop: false,
      dialogBorderRadius: BorderRadius.circular(25),
      dialogBackgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850]
          : Colors.white,
      customHeader: const Icon(
        Icons.person,
        size: 90,
        color: kGreenColor1,
      ),
      body: _DialogBody(
        controller: nameController,
        onSubmit: (value) {
          // Save to storage
          box.write('userName', value);
          //save isregisted
          box.write('isRegistered', true);
          // Navigate to home screen
          Get.offAll(() => const HomeScreen());
          completer.complete();
        },
      ),
      btnOk: Container(),
      btnCancel: Container(),
    ).show();

    return completer.future;
  }
}

class _DialogBody extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmit;

  const _DialogBody({
    required this.controller,
    required this.onSubmit,
  });

  @override
  State<_DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<_DialogBody> {
  bool isNameEmpty = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850]
        : Colors.white;
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? kWhiteColor
        : kGreenColor1;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            "Dear Farmer, please enter your first or last name",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color:kGreenColor1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.controller,
            maxLength: 15,
            decoration: InputDecoration(
              hintText: "Nimal",
              hintStyle: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: kGreyColor2,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              counterText: '',
              errorText: isNameEmpty ? "Name is required" : null,
              errorStyle: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              filled: true,
              fillColor: backgroundColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                isNameEmpty = value.trim().isEmpty;
              });
            },
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRedColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenColor2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    final input = widget.controller.text.trim();
    if (input.isEmpty) {
      setState(() {
        isNameEmpty = true;
      });
    } else {
      widget.onSubmit(input);
    }
  }
}

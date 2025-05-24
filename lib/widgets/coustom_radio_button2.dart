import 'package:cvui/utils/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoustomRadioButton2 extends StatelessWidget {
  const CoustomRadioButton2(
      {super.key,
      required this.mController,
      required this.title,
      required this.val});
  final val;
  final mainController mController;
  final title;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Radio<String>(
              activeColor: Colors.white,
              value: val,
              groupValue: mController.deviceSelector.value,
              onChanged: (value) {
                mController.deviceSelector.value = value!;
              }),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

import 'package:cvui/utils/controller.dart';
import 'package:cvui/utils/contsants.dart';
import 'package:flutter/material.dart';

class RtspSelector extends StatelessWidget {
  RtspSelector({
    required this.mController,
    super.key,
  });
  mainController mController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 40,
      child: TextField(
        controller: mController.rtspcontroller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            hintText: "rtsp://...",
            hintStyle: TextStyle(color: Colors.white70.withOpacity(0.1)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: borderColor))),
      ),
    );
  }
}

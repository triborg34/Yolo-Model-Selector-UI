import 'dart:typed_data';
import 'package:cvui/utils/controller.dart';
import 'package:cvui/utils/contsants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class imageSelector extends StatelessWidget {
   imageSelector({
    required this.mController,
    super.key,
  });

  mainController mController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

            if (result != null) {
              Uint8List fileBytes = result.files.first.bytes!;
              mController.fileName.value = result.files.single.name;
              // print(result.files.first.path);

              await uploadVideoFile(
                  fileBytes, 'copy${mController.fileName.value}', mController);
            } else {
              // User canceled the picker
            }
          },
          child: Obx(
            () => Text(
              mController.fileName.value == ''
                  ? "Select a Image"
                  : mController.fileName.value,
              style: TextStyle(color: borderColor),
            ),
          )),
    );
  }
}

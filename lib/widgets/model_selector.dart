import 'dart:typed_data';
import 'package:cvui/utils/controller.dart';
import 'package:cvui/utils/contsants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({
    super.key,
    required this.mController,
  });

  final mainController mController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pt']);

          if (result != null) {
            Uint8List fileBytes = result.files.first.bytes!;
            mController.modelname.value = result.files.single.name;
            // print(result.files.first.path);

            await uploadModelFile(
                fileBytes, '${mController.modelname.value}', mController);
          } else {
            // User canceled the picker
          }
        },
        child: Obx(() => Text(
              mController.modelname.value,
              style: TextStyle(color: borderColor),
            )));
  }
}

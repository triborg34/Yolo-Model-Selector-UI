import 'package:cvui/utils/camerafeed.dart';
import 'package:cvui/utils/controller.dart';
import 'package:cvui/utils/contsants.dart';
import 'package:cvui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.sizeOf(context).width);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Row(
          children: [
            sidebar(),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderColor, width: 3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 1280,
                    height: 720,
                    decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    child: Obx(
                      () => Get.find<mainController>().url.value == false
                          ? Center(
                              child: Text("No Camera"),
                            )
                          : CameraFeed(
                              streamUrl:
                              Get.find<mainController>().soruceSelection.value=="image" ? 
                              'http://127.0.0.1:8000/image?imgPath=${ Get.find<mainController>().soruce.value}&path=${Get.find<mainController>().modelPath}' :
                                  'http://127.0.0.1:8000/?source=${Get.find<mainController>().soruce.value}&path=${Get.find<mainController>().modelPath == '' ? "models/yolov8n.pt" : Get.find<mainController>().modelPath}&device=${Get.find<mainController>().deviceSelector.value}&conf=${(Get.find<mainController>().sliderController.value * 100).toInt().toString()}'),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

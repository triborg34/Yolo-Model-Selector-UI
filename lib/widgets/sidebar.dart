
import 'package:cvui/utils/controller.dart';

import 'package:cvui/utils/contsants.dart';
import 'package:cvui/widgets/coustom_radio_button.dart';
import 'package:cvui/widgets/coustom_radio_button2.dart';
import 'package:cvui/widgets/model_selector.dart';
import 'package:cvui/widgets/rtsp_selector.dart';
import 'package:cvui/widgets/video_selector.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class sidebar extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final mainController mController = Get.find<mainController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 3)),
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.network(
              'assets/images/yoloLogo.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Ultralytics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Select Source",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoustomRadioButton(
                mController: mController,
                title: 'WebCam',
                val: 'webcam',
              ),
              CoustomRadioButton(
                  mController: mController, title: 'Video', val: 'video'),
              CoustomRadioButton(
                  mController: mController, title: 'RTSP', val: 'rtsp')
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => mController.soruceSelection.value == 'webcam'
                ? Container()
                : mController.soruceSelection.value == 'video'
                    ? VideoSelector(
                        mController: mController,
                      )
                    : RtspSelector(mController: mController),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CoustomRadioButton2(
                  mController: mController, title: 'Cpu', val: 'cpu'),
              CoustomRadioButton2(
                  mController: mController, title: 'Cuda', val: 'cuda'),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: Slider(
                      activeColor: borderColor,
                      value: mController.sliderController.value,
                      onChanged: (value) {
                        mController.sliderController.value = value;
                      },
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 40,
                      child: Text(
                        (mController.sliderController.value * 100)
                                .toInt()
                                .toString() +
                            "%",
                        style: TextStyle(color: borderColor),
                      ))
                ],
              )),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 200,
            height: 50,
            child: ModelSelector(mController: mController),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              width: 200,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    if (mController.soruceSelection.value == 'video') {
                      mController.soruce.value = mController.saveDir.value;
                    } else if (mController.soruceSelection.value == 'rtsp') {
                      mController.soruce.value =
                          mController.rtspcontroller.text;
                    
                    } else {
                      mController.soruce.value = '0';
                    }

                    mController.url.value = true;
                  },
                  child: Text(
                    "Connect",
                    style: TextStyle(color: borderColor),
                  ))),SizedBox(height: 15,),
                        Container(
              width: 200,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                   

                    mController.url.value = false;
                    Get.find<CameraController>().disconnectAll();
                  },
                  child: Text(
                    "Disconnect",
                    style: TextStyle(color: borderColor),
                  )))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
class mainController extends GetxController{
  var url=false.obs;

  var soruceSelection='rtsp'.obs;
  var fileName="".obs;
  var saveDir=''.obs;
  var soruce=''.obs;
  var modelname='Upload Model'.obs;
  var modelPath=''.obs;
  var deviceSelector='cpu'.obs;
  var sliderController=0.7.obs;
  TextEditingController rtspcontroller=TextEditingController();
}




class CameraController extends GetxController {
  final _cameras = <String, html.ImageElement>{}.obs;

  void connect(String url, String viewId) {
    final imgElement = html.ImageElement()
      ..src = url
      ..id = viewId
      ..style.width = '100%'
      ..style.height = '100%'
        
  
      ..style.objectFit = 'cover';
      

    _cameras[viewId] = imgElement;
  }

  html.ImageElement? getElement(String viewId) => _cameras[viewId];

  void disconnect(String viewId) {
    print(viewId);
    final element = _cameras[viewId];
    if (element != null) {
      element.src = '';
      element.remove();
      _cameras.remove(viewId);
    }
  }

  /// 🔌 Disconnects all active camera streams
  void disconnectAll() {
    final keys = _cameras.keys.toList(); // Avoid concurrent modification
    for (final viewId in keys) {
      disconnect(viewId);
    }
  }

  @override
  void onClose() {
    disconnectAll();
    super.onClose();
  }
}
import 'package:cvui/utils/controller.dart';
import 'package:get/get.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => mainController());
    Get.lazyPut(()=>CameraController());
    
  }
}

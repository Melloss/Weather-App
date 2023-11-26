import 'package:get/get.dart';
import './data_controller.dart';

Future initController() async {
  Get.lazyPut(() => DataController());
}

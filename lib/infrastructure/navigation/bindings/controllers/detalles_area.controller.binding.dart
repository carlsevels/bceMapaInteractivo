import 'package:get/get.dart';

import '../../../../presentation/detallesArea/controllers/detalles_area.controller.dart';

class DetallesAreaControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetallesAreaController>(
      () => DetallesAreaController(),
    );
  }
}

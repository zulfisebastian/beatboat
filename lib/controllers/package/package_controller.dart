import 'package:beatboat/widgets/pages/loading.dart';
import 'package:get/get.dart';
import '../../models/package/package_model.dart';
import '../../repositories/package/package_repo.dart';

class PackageController extends GetxController {
  final PackageRepo _transactionRepo = Get.put(PackageRepo());

  @override
  void onReady() {
    super.onReady();
  }

  RxString uuid = "".obs;

  RxList<PackageData> listPackage = <PackageData>[].obs;
  getDataPackage() async {
    var _resp = await _transactionRepo.getPackage(uuid.value);

    if (_resp.data != null) {
      listPackage.value = _resp.data!;
      listPackage.refresh();
    }
  }
}

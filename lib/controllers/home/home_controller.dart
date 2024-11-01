import 'package:beatboat/models/activity/activity_model.dart';
import 'package:beatboat/models/product/category_model.dart';
import 'package:beatboat/models/product/product_model.dart';
import 'package:beatboat/repositories/activity/activity_repo.dart';
import 'package:beatboat/repositories/product/product_repo.dart';
import 'package:beatboat/repositories/resource/resource_repo.dart';
import 'package:beatboat/widgets/sheets/sheet_resource_update.dart';
import 'package:get/get.dart';
import '../../models/auth/menu_model.dart';
import '../../models/balance/balance_model.dart';
import '../../models/resource/resource_model.dart';
import '../../services/databases/product/category_table.dart';
import '../../services/databases/profile/menu_table.dart';
import '../../widgets/sheets/sheet_failed.dart';
import '../../widgets/sheets/sheet_success.dart';
import '../base/base_controller.dart';

class HomeController extends GetxController {
  RxList<ProductData> listProductDummy = <ProductData>[].obs;
  final BaseController _base = Get.find(tag: "BaseController");

  final ProductRepo _productRepo = Get.put(ProductRepo());
  final ActivityRepo _activityRepo = Get.put(ActivityRepo());
  final ResourceRepo _resourceRepo = Get.put(ResourceRepo());

  @override
  void onReady() {
    super.onReady();
    initAllData();
  }

  initAllData() async {
    await _base.initLink();
    await getDataMenu();
    await getDataCategory();
    await getDataActivity();

    if (_base.dataVersion.value.is_need_update == 1) {
      // Get.dialog(
      //   UpdateApp(
      //     oncallbackCancel: () {
      //       Get.back();
      //     },
      //   ),
      //   barrierDismissible: true,
      // );
    }
  }

  RxList<CategoryData> listCategory = <CategoryData>[].obs;
  getDataCategory() async {
    await _base.initConnectivity();
    if (_base.isConnected.value) {
      var _resp = await _productRepo.getCategory();

      if (_resp.data!.length > 0) {
        listCategory.value = _resp.data!;
        listCategory.refresh();
      }
    } else {
      var _resp = await CategoryTable().getAllCategory();

      if (_resp != null) {
        listCategory.value = _resp;
        listCategory.refresh();
      }
    }
  }

  RxList<MenuData> listMenu = <MenuData>[].obs;
  getDataMenu() async {
    await _base.initConnectivity();
    if (_base.isConnected.value) {
      await _base.getProfile();

      listMenu.value = _base.dataProfile.value.menus!;
      listMenu.refresh();
    } else {
      var _resp = await MenuTable().getAllMenu();

      if (_resp != null) {
        listMenu.value = _resp;
        listMenu.refresh();
      }
    }
  }

  RxList<ActivityData> listActivity = <ActivityData>[].obs;
  getDataActivity() async {
    var body = {
      "per_page": 6,
      "page": 1,
    };
    var _resp = await _activityRepo.getActivity(body);

    if (_resp.data!.length > 0) {
      listActivity.value = _resp.data!;
      listActivity.refresh();
    }
  }

  RxList<ResourceData> listResource = <ResourceData>[].obs;
  Rx<ResourceData> choosedResource = ResourceData().obs;
  Rx<BalanceData> balance = BalanceData().obs;

  getDataResource() async {
    var _resp = await _resourceRepo.getResource();

    if (_resp.data!.length > 0) {
      listResource.value = _resp.data!;
      listResource.refresh();
      Get.bottomSheet(
        SheetResourceUpdate(),
        isScrollControlled: true,
      );
    }
  }

  updateDataResource() async {
    String udid = Get.find(tag: "udid");

    var body = {
      "device_serial_number": udid,
      "nfc_uid": balance.value.nfc_uid,
      "resource_tag": choosedResource.value.resource_tag,
    };

    var _resp = await _resourceRepo.updateResource(body);

    if (_resp.code != null) {
      Get.back();

      balance.value = BalanceData();
      choosedResource.value = ResourceData();
      balance.refresh();
      choosedResource.refresh();

      Get.bottomSheet(
        SheetSuccess(
          message: "Wristband updated successfully",
        ),
        isScrollControlled: true,
      );
    } else {
      Get.bottomSheet(
        SheetFailed(
          errorMessage: _resp.message!,
        ),
        isScrollControlled: true,
      );
    }
  }
}

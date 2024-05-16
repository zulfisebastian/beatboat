import 'package:beatboat/models/activity/activity_model.dart';
import 'package:beatboat/repositories/activity/activity_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  final ActivityRepo _activityRepo = Get.put(ActivityRepo());

  final scrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    scrollController.addListener(scrollControllerListener);
    initAllData();
  }

  bool isLoading = false;
  RxBool isLoadMoreData = false.obs;
  RxInt page = 0.obs;
  RxInt totalPage = 1.obs;

  void scrollControllerListener() async {
    if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels &&
        !isLoading &&
        page.value < totalPage.value) {
      isLoading = true;
      isLoadMoreData.value = true;
      getDataActivity(true);
    }
  }

  initAllData() {
    getDataActivity();
  }

  RxList<ActivityData> listActivity = <ActivityData>[].obs;
  getDataActivity([bool isMore = false]) async {
    var body = {
      "per_page": 10,
      "page": page.value + 1,
    };

    var _resp = await _activityRepo.getActivity(body);

    if (_resp.data != null) {
      if (isMore) {
        listActivity.addAll(_resp.data!);
      } else {
        listActivity.value = _resp.data!;
      }
      page.value = _resp.paging!.current_page!;
      totalPage.value = _resp.paging!.last_page!;
      isLoadMoreData.value = false;
      isLoading = false;
      listActivity.refresh();
    }
  }
}

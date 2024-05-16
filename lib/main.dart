import 'dart:io';
import 'package:beatboat/pages/auth/login.dart';
import 'package:beatboat/pages/home/home.dart';
import 'package:beatboat/services/databases/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'controllers/base/base_controller.dart';
import 'controllers/theme/theme_controller.dart';
import 'services/init_depedencies.dart';
import 'utils/shared_pref.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(BaseController(), tag: 'BaseController');
  Get.put(ThemeController(), tag: 'ThemeController');
  Get.put(DatabaseServices(), tag: 'DatabaseServices');
  HttpOverrides.global = new MyHttpOverrides();

  await InitDepedencies().initPlatformState();
  await InitDepedencies().getVersionCode();
  await InitDepedencies().getDeviceInfo();
  await InitDepedencies().initErrorWidget();
  await InitDepedencies().initGoogleSignIn();

  // calculate token expired date
  String _accessToken = await SharedPref.getAccessToken();
  bool _isNeedLogin = true;
  BaseController _controller = Get.find(tag: "BaseController");
  if (_accessToken.isNotEmpty) {
    _isNeedLogin = false;
    await _controller.changeIsLogedIn();
  }

  // DynamicLinkService _dynamicLinkService = Get.put(
  //   DynamicLinkService(),
  //   tag: "dynamicLink",
  // );
  // _dynamicLinkService.initDynamicLinks();

  // bool _isVersionValidate = true;
  // _isVersionValidate = await _controller.checkVersion();

  await initializeDateFormatting('id_ID', null).then(
    (_) => runApp(
      MyApp(
        page: _isNeedLogin ? LoginPage() : HomePage(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? page;
  const MyApp({
    Key? key,
    this.page,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  final BaseController control = Get.find(tag: 'BaseController');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    control.initConnectivity();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        print("INACTIVE");
        control.initConnectivity();
        break;
      case AppLifecycleState.paused:
        print("PAUSED");
        control.initConnectivity();
        break;
      case AppLifecycleState.detached:
        print("DETACH");
        break;
      case AppLifecycleState.resumed:
        print("RESUMED");
        control.initConnectivity();
        break;
      case AppLifecycleState.hidden:
        print("HIDDEN");
        control.initConnectivity();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: _theme.backgroundApp.value,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      title: 'Beat Boat',
      theme: ThemeData(fontFamily: 'Segoeui'),
      home: widget.page,
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
        );
      },
    );
  }
}

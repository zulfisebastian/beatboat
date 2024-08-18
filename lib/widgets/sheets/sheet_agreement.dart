import 'package:beatboat/constants/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme/theme_controller.dart';
import '../../utils/extensions.dart';
import '../components/customButton.dart';
import '../components/text/ctext.dart';

class SheetAgreement extends StatefulWidget {
  final VoidCallback onAgree;
  SheetAgreement({
    Key? key,
    required this.onAgree,
  }) : super(key: key);

  @override
  State<SheetAgreement> createState() => _SheetAgreementState();
}

class _SheetAgreementState extends State<SheetAgreement> {
  final ThemeController _theme = Get.find(tag: 'ThemeController');
  late bool isAgree = false;
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse("https://beatboat.com/terms-and-conditions/"));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 0.945,
      minChildSize: 0.945,
      maxChildSize: 0.955,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: _theme.backgroundApp.value,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              width: OtherExt().getWidth(context),
              height: OtherExt().getHeight(context),
              child: Stack(
                children: <Widget>[
                  WebViewWidget(
                    controller: _controller,
                    gestureRecognizers: Set()
                      ..add(
                        Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer(),
                        ),
                      ),
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: OtherExt().getWidth(context),
                      decoration: BoxDecoration(
                        color: _theme.white.value,
                        boxShadow: [
                          BoxShadow(
                            color: _theme.textTitle.value.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: CDimension.space20,
                        vertical: CDimension.space6,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    isAgree = value!;
                                  });
                                },
                                value: isAgree,
                                checkColor: Colors.white,
                                activeColor: _theme.accent.value,
                                side: BorderSide(
                                  color: _theme.textTitle.value,
                                  width: 1,
                                ),
                              ),
                              CText(
                                "I agree to the Terms and Conditions",
                                color: _theme.textTitle.value,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: CDimension.space4,
                          ),
                          CustomButtonBlue(
                            "Pair Now",
                            width: OtherExt().getWidth(context),
                            disabled: !isAgree,
                            onPressed: () {
                              widget.onAgree();
                            },
                          ),
                          SizedBox(
                            height: CDimension.space8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

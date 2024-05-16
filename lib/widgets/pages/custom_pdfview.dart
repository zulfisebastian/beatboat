import 'package:beatboat/utils/extensions.dart';
import 'package:beatboat/widgets/components/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class CustomPDFView extends StatefulWidget {
  final String title;
  final String url;
  final Function onDownload;

  const CustomPDFView({
    Key? key,
    required this.title,
    required this.url,
    required this.onDownload,
  }) : super(key: key);

  @override
  State<CustomPDFView> createState() => _CustomPDFViewState();
}

class _CustomPDFViewState extends State<CustomPDFView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: widget.title,
        action: GestureDetector(
          onTap: () {
            widget.onDownload();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.file_download_outlined,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: RawScrollbar(
        thumbColor: Colors.redAccent,
        radius: Radius.circular(20),
        thickness: 4,
        child: Container(
          height: OtherExt().getHeight(context) - kToolbarHeight,
          child: PDF(
            swipeHorizontal: false,
            fitPolicy: FitPolicy.BOTH,
          ).cachedFromUrl(
            widget.url,
            placeholder: (progress) => Center(child: Text('$progress %')),
          ),
        ),
      ),
    );
  }
}

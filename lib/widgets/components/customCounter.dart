import 'package:beatboat/constants/dimension.dart';
import 'package:beatboat/widgets/components/text/ctext.dart';
import 'package:flutter/material.dart';

class CustomCounter extends StatelessWidget {
  const CustomCounter({
    Key? key,
    required this.qty,
    required this.onDecrease,
    required this.onIncrease,
    required this.decreaseBackground,
    required this.increaseBackground,
    required this.qtyColor,
    this.sizeIcon = CDimension.space40,
    this.sizeQty = 20,
  });

  final int qty;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final Color decreaseBackground;
  final Color increaseBackground;
  final Color qtyColor;
  final double sizeIcon;
  final double sizeQty;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onDecrease();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: sizeIcon,
            height: sizeIcon,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: decreaseBackground,
            ),
            child: Center(
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: CDimension.space20,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: CDimension.space20,
          ),
          child: CText(
            qty,
            color: qtyColor,
            fontSize: sizeQty,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            onIncrease();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: sizeIcon,
            height: sizeIcon,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: increaseBackground,
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: CDimension.space20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

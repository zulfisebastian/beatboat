import 'package:flutter/material.dart';

class CRadio extends StatelessWidget {
  final int value;
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final bool isActive;
  final Function(int) onTap;

  CRadio({
    required this.value,
    required this.child,
    required this.backgroundColor,
    required this.borderColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(value);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 0.5,
              ),
            ),
            child: isActive
                ? Center(
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : Container(),
          ),
          SizedBox(
            width: 10,
          ),
          child,
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../main.dart';
import '../constants/constants.dart';
import 'rounded_button.dart';

class CustomDialogs {
  void _genericAlertDilaog({
    required IconData icon,
    required String title,
    required String message,
    required Widget bottomWidget,
    bool? barrierDismissible,
    int maxSubLines = 3,
    Color iconColor = MyColors.primary,
    Color titleColor = MyColors.primary,
  }) {
    showDialog(
      context: navKey.currentContext!,
      barrierDismissible: barrierDismissible ?? true,
      useSafeArea: false,
      builder: (context) => _CustomDialogView(
        title: title,
        description: message,
        icon: icon,
        bottomWidget: bottomWidget,
        maxSubLines: maxSubLines,
      ),
    );
  }

  void errorBox({
    String? message,
    String? negativeTitle,
    String? positiveTitle,
    VoidCallback? onNegativePressed,
    VoidCallback? onPositivePressed,
    bool showPositive = false,
  }) {
    _genericAlertDilaog(
      icon: Icons.bug_report,
      title: "Error",
      titleColor: Colors.red,
      message: message ?? "Error",
      iconColor: Colors.red,
      bottomWidget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showPositive)
            RoundedButton(
              title: positiveTitle ?? "Go",
              height: 44,
              textSize: 12,
              onPressed: () {
                Navigator.of(navKey.currentContext!).pop();
                if (onPositivePressed != null) {
                  onPositivePressed();
                }
              },
            ),
          if (showPositive) gapH6,
          RoundedButton(
            title: negativeTitle ?? "Close",
            withBorderOnly: true,
            height: 44,
            textSize: 12,
            onPressed: onNegativePressed ??
                () {
                  Navigator.of(navKey.currentContext!).pop();
                },
          ),
        ],
      ),
    );
  }

  void alertBox({
    String? message,
    String? title,
    String? negativeTitle,
    String? positiveTitle,
    VoidCallback? onNegativePressed,
    VoidCallback? onPositivePressed,
    IconData? icon,
    bool showNegative = true,
  }) {
    _genericAlertDilaog(
      icon: icon ?? Icons.warning,
      title: title ?? "Alert!",
      message: message ?? "Alet",
      bottomWidget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundedButton(
            title: positiveTitle ?? "Done",
            height: 44,
            textSize: 12,
            onPressed: () {
              Navigator.of(navKey.currentContext!).pop();
              if (onPositivePressed != null) {
                onPositivePressed();
              }
            },
          ),
          if (showNegative) gapH6,
          if (showNegative)
            RoundedButton(
              title: negativeTitle ?? "Cancel",
              withBorderOnly: true,
              height: 44,
              textSize: 12,
              onPressed: onNegativePressed ??
                  () {
                    Navigator.of(navKey.currentContext!).pop();
                  },
            ),
        ],
      ),
    );
  }

  void deleteBox(
      {required String title,
      required String message,
      required VoidCallback onPositivePressed}) {
    alertBox(
      title: title,
      message: message,
      onPositivePressed: onPositivePressed,
      positiveTitle: "Delete",
      icon: Icons.delete,
    );
  }

  void successBox({
    String? title,
    required String message,
    VoidCallback? onPositivePressed,
    VoidCallback? onNegativePressed,
    String? positiveTitle,
    String? negativeTitle,
    bool? barrierDismissible,
  }) {
    _genericAlertDilaog(
      icon: Icons.check,
      title: title ?? "Success",
      barrierDismissible: barrierDismissible,
      message: message,
      maxSubLines: 6,
      bottomWidget: Column(
        children: [
          Column(
            children: [
              RoundedButton(
                title: positiveTitle ?? "Done",
                height: 50,
                onPressed: () {
                  Navigator.of(navKey.currentContext!).pop();
                  if (onPositivePressed != null) {
                    onPositivePressed();
                  }
                },
              ),
              if (negativeTitle != null) gapH6,
              if (negativeTitle != null)
                RoundedButton(
                  title: negativeTitle,
                  height: 50,
                  onPressed: () {
                    Navigator.of(navKey.currentContext!).pop();
                    if (onNegativePressed != null) {
                      onNegativePressed();
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomDialogView extends StatefulWidget {
  const _CustomDialogView(
      {required this.title,
      required this.description,
      required this.icon,
      required this.bottomWidget,
      required this.maxSubLines});
  final String title;
  final String description;
  final IconData icon;

  final Widget bottomWidget;
  final int maxSubLines;

  @override
  State<_CustomDialogView> createState() => _CustomDialogViewState();
}

class _CustomDialogViewState extends State<_CustomDialogView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.6),
          body: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: SCREEN_WIDTH * 0.9,
                  margin: EdgeInsets.only(bottom: 3.5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        gapH10,
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        gapH6,
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.description,
                          // maxLines: widget.maxSubLines,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2F3342).withOpacity(0.80),
                          ),
                        ),
                        gapH10,
                        widget.bottomWidget,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

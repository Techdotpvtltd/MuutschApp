import 'package:flutter/material.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/text_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 20.h,
                color: Color(0xffBD9691),
              ),
              Expanded(
                  child: Container(
                color: Color(0xfff2f2f2),
              ))
            ],
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Remix.arrow_left_s_line,
                              color: Colors.white, size: 4.h),
                          SizedBox(width: 2.w),
                          text_widget("Search",
                              color: Colors.white, fontSize: 18.sp),
                          Spacer(),
                          Image.asset("assets/icons/list.png", height: 2.5.h),
                          SizedBox(width: 4.w),
                          Image.asset("assets/icons/filter.png", height: 2.5.h),
                          SizedBox(width: 4.w),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Search ",
                        // controller: _.password,
                        fillColor: Colors.white,
                        isPrefix: true,
                        prefixIcon: "assets/nav/s1.png",
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        suffixIcon: "assets/icons/fil2.png",
                        isSuffix: true,
                      ),
                      Spacer(),
                      Image.asset("assets/images/no.png"),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

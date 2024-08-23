import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/privacy/privacy_bloc.dart';
import 'package:musch/blocs/privacy/privacy_event.dart';
import 'package:musch/blocs/privacy/privacy_state.dart';
import 'package:musch/utils/constants/constants.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/privacy_model.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final bool isDrawer;
  const PrivacyPolicyPage({super.key, required this.isDrawer});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  List<PrivacyModel> privacies = [];
  bool isLoading = false;

  void triggerFetchAllPrivaciesEvent() {
    context.read<PrivacyBloc>().add(PrivacyEventFetch());
  }

  @override
  void initState() {
    triggerFetchAllPrivaciesEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrivacyBloc, PrivacyState>(
      listener: (context, state) {
        if (state is PrivacyStateFetchFailure ||
            state is PrivacyStateFetched ||
            state is PrivacyStateFetching) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is PrivacyStateFetched) {
            setState(() {
              privacies = state.privacies;
            });
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Color(0xffF2F2F2),
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.black,
                              size: 4.h,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          textWidget(
                            "Privacy Policy",
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                        ],
                      ),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                physics: ScrollPhysics(),
                                itemCount: privacies.length,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                itemBuilder: (ctx, index) {
                                  final PrivacyModel privacy = privacies[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Colors.black,
                                          ),
                                          gapW8,
                                          Flexible(
                                            child: Text(
                                              privacy.heading,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 10,
                                          bottom: 5,
                                        ),
                                        child: Text(privacy.content),
                                      )
                                    ],
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

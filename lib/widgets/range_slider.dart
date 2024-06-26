import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class RangeSliderLabelWidget extends StatefulWidget {
  final String title;
  RangeSliderLabelWidget({super.key, required this.title});

  @override
  _RangeSliderLabelWidgetState createState() => _RangeSliderLabelWidgetState();
}

class _RangeSliderLabelWidgetState extends State<RangeSliderLabelWidget> {
  RangeValues values = RangeValues(22, 32);

  @override
  Widget build(BuildContext context) => SliderTheme(
      data: SliderThemeData(
        activeTrackColor: MyColors.primary,
        rangeThumbShape: CircleThumbShape(),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
      ),

      // data: SliderTheme.of(context).copyWith(
      // activeTrackColor: MyColors.primary,
      // minThumbSeparation: 40,
      // inactiveTrackColor: Colors.grey,
      // trackShape: RoundedRectSliderTrackShape(),
      // trackHeight: 1.6,
      // rangeThumbShape: RoundRangeSliderThumbShape(
      //     enabledThumbRadius: 10.0, elevation: 6, pressedElevation: 6),
      // thumbColor: MyColors.primary,
      // overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
      // overlappingShapeStrokeColor: Colors.transparent,
      // overlayColor: Colors.transparent,
      // activeTickMarkColor: Colors.transparent,
      // inactiveTickMarkColor: Colors.transparent,
      // valueIndicatorColor: Colors.transparent,
      // showValueIndicator: ShowValueIndicator.onlyForDiscrete,
      // valueIndicatorTextStyle: GoogleFonts.roboto(
      //     color: MyColors.primary,
      //     fontSize: 13.sp,
      //     fontWeight: FontWeight.w400)),

      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 1.8.h),
            child: buildLabel(label: widget.title, color: Colors.white)),
        Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: RangeSlider(
                values: values,
                onChanged: (RangeValues value) {
                  setState(() {
                    values = value;
                  });
                  // widget.fun(value);
                },
                divisions: 62,
                labels: RangeLabels(
                  widget.title == "Length"
                      ? values.start.round().toString()
                      : values.start.round().toString() + " Km",
                  widget.title == "Length"
                      ? values.end.round().toString()
                      : values.end.round().toString() + " Km",
                ),
                min: 18,
                max: 80)),
        SizedBox(height: .5.h),
        Row(
          children: [
            text_widget("5KM",
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff8C8C8C)),
            Spacer(),
            text_widget("50KM",
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff8C8C8C)),
          ],
        ),
      ]));

  Widget buildLabel({required String label, required Color color}) => Text(
      label.toString(),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600)
          .copyWith(color: MyColors.black));
}

class CircleThumbShape extends RangeSliderThumbShape {
  const CircleThumbShape({this.thumbRadius = 10.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = MyColors.primary
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(center, thumbRadius, fillPaint)
      ..drawCircle(center, thumbRadius, borderPaint);
  }
}

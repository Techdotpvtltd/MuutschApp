// Project: 	   listi_shop
// File:    	   custom_dropdown
// Path:    	   lib/screens/components/custom_dropdown.dart
// Author:       Ali Akbar
// Date:        23-04-24 16:54:23 -- Tuesday
// Description:

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants/constants.dart';
import 'style_guide.dart';

class CustomTextFieldDropdown extends StatefulWidget {
  const CustomTextFieldDropdown({
    super.key,
    this.titleText,
    required this.hintText,
    required this.items,
    required this.onSelectedItem,
    this.selectedValue,
  });
  final String? titleText;
  final String hintText;
  final List<String> items;
  final Function(String) onSelectedItem;
  final String? selectedValue;

  @override
  State<CustomTextFieldDropdown> createState() =>
      _CustomTextFieldDropdownState();
}

class _CustomTextFieldDropdownState extends State<CustomTextFieldDropdown> {
  bool isShowPassword = true;
  List<String> items = [];
  late String? strVal = widget.selectedValue;
  @override
  void initState() {
    setState(() {
      items = widget.items;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
          maxHeight: SCREEN_HEIGHT * 0.4,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.zero,
        ),
        alignment: Alignment.centerLeft,
        items: items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          widget.onSelectedItem(value ?? "");
          setState(() {
            strVal = value;
          });
        },
        hint: Text.rich(
          TextSpan(
            text: widget.hintText == "" ? "" : "${widget.hintText}: ",
            children: [
              TextSpan(
                text: strVal,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF838383),
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFC),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              color: const Color(0xFFDADFEA),
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// ===========================Custom Icon Dropdown================================
class CustomIconButtonDropdown extends StatelessWidget {
  const CustomIconButtonDropdown({
    required this.items,
    required this.onSelectedItem,
    super.key,
    this.icon,
    this.isFilled = true,
    this.width,
    this.height,
  });
  final List<String> items;
  final Function(String, int) onSelectedItem;
  final Widget? icon;
  final bool isFilled;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: icon ??
              const Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
              ),
          items: items
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            direction: DropdownDirection.left,
            width: 160,
          ),
          buttonStyleData: ButtonStyleData(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: isFilled ? const Color(0xFFDFE4E5) : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: const Color(0xFFDFE4E5), width: 1),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              final int index = items
                  .indexWhere((e) => e.toLowerCase() == value.toLowerCase());
              onSelectedItem(value, index);
            }
          },
        ),
      ),
    );
  }
}

// ===========================Custom Button Dropdoown================================

class CustomMenuDropdown extends StatelessWidget {
  const CustomMenuDropdown(
      {required this.items,
      required this.onSelectedItem,
      super.key,
      this.icon,
      this.width,
      this.buttonColor,
      this.iconData});
  final List<DropdownMenuModel> items;
  final Function(String, int) onSelectedItem;
  final Widget? icon;
  final Color? buttonColor;
  final double? width;
  final IconData? iconData;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: icon ??
            Icon(
              iconData ?? Icons.more_vert_outlined,
              color: buttonColor ?? Colors.white,
            ),
        items: items
            .map(
              (DropdownMenuModel item) => DropdownMenuItem<String>(
                value: item.title,
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color:
                          item.icon == Icons.delete ? Colors.red : Colors.white,
                    ),
                    gapW10,
                    Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        color: item.icon == Icons.delete
                            ? Colors.red
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        dropdownStyleData: DropdownStyleData(
          decoration: const BoxDecoration(
            color: StyleGuide.widgetColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          direction: DropdownDirection.left,
          width: width ?? 160,
        ),
        onChanged: (value) {
          if (value != null) {
            final int index = items.indexWhere(
                (e) => e.title.toLowerCase() == value.toLowerCase());
            onSelectedItem(value, index);
          }
        },
      ),
    );
  }
}

class DropdownMenuModel {
  final String title;
  final IconData icon;

  DropdownMenuModel({required this.title, required this.icon});
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onItemSelected,
    this.titleLabel,
    this.selectedValue,
  });
  final List<String> items;
  final String hintText;
  final Function(String, int) onItemSelected;
  final String? titleLabel;
  final String? selectedValue;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String? selectedValue = widget.selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleLabel != null)
          Text(
            widget.titleLabel ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        if (widget.titleLabel != null) gapH10,
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            dropdownStyleData: const DropdownStyleData(
              decoration: BoxDecoration(
                color: StyleGuide.textFiledBackgroundColor,
              ),
            ),
            isExpanded: true,
            items: widget.items
                .map(
                  (name) => DropdownMenuItem<String>(
                    value: name,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              widget.hintText,
              style: StyleGuide.placeHolderTS,
            ),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              final int index = widget.items.indexWhere(
                  (element) => element.toLowerCase() == value?.toLowerCase());
              if (index > -1) {
                widget.onItemSelected(value!, index);
              }
            },
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                color: StyleGuide.textFiledBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.white12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

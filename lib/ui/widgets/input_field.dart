import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/Themes.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            height: 52,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: controller,
                        autofocus: false,
                        readOnly: widget==null ? false : true,
                        cursorColor: Get.isDarkMode
                            ? Colors.grey[100]
                            : Colors.grey[700],
                        style: subTitleStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: subTitleStyle,
                          // focusedBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: context.theme.backgroundColor,
                          //     width: 0
                          //   )
                          // ),
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(
                          //         color: context.theme.backgroundColor,
                          //         width: 0
                          //     )
                          // ),
                        )
                    )),
                widget==null ? Container() : Container(
                  child: widget,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

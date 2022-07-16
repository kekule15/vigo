
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vigo/enums/text_field_type_enum.dart';

class CustomField extends StatelessWidget {
  CustomField(
      {Key? key,
      this.hint = '',
      this.width,
      this.height,
      this.sIcon,
      this.pIcon,
      this.obscureText = false,
      this.isWordField = true,
      this.maxline,
      this.controller,
      this.contentPadding,
      this.onChanged,
      this.hintstyle,
      this.hintColor,
      this.headtext,
      this.keyboardType,
      this.validate = true,
      this.readonly = false,
      this.autoFocus = false,
      this.fieldType,
      this.maxLength,
      this.useNativeKeyboard = true,
      this.inputDecoration,
      this.fillColor,
      this.onCompleted,
      this.enabledBorder,
      this.focusedBorder,
      this.style,
      this.borderSide,
      this.textInputFormatters,
      this.shape = BoxShape.rectangle,
      this.focusNode,
      this.validator})
      : super(key: key);

  final Function(String)? onCompleted;
  final String hint;
  final _pinPutFocusNode = FocusNode();
  final Color? fillColor;
  final bool useNativeKeyboard;
  final double? width;
  final double? height;
  final Widget? sIcon;
  final Widget? pIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final InputDecoration? inputDecoration;
  final Function? validator;
  final TextStyle? hintstyle;
  final Color? hintColor;
  final int? maxline;
  final String? headtext;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextFieldType? fieldType;
  final bool isWordField;
  final bool validate;
  final bool readonly;
  final BorderRadius? enabledBorder;
  final BorderRadius? focusedBorder;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool autoFocus;
  final BoxShape? shape;
  final TextStyle? style;
  final BorderSide? borderSide;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? textInputFormatters;

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: fillColor ?? Theme.of(context).inputDecorationTheme.fillColor,
      shape: shape ?? BoxShape.rectangle,
      borderRadius:
          shape == BoxShape.circle ? null : BorderRadius.circular(5.0),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headtext == null
            ? const SizedBox.shrink()
            : Text(headtext!,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black)),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            flex: 0,
            //height: inputFieldHeight,
            child: SizedBox(
              width: width,
              height: height,
              child: TextFormField(
                focusNode: focusNode,
                maxLines: maxline ?? 1,
                maxLength: maxLength,
                obscureText: obscureText,
                controller: controller,
                readOnly: readonly,
                autofocus: false,
                // scrollPadding: EdgeInsets.only(bottom: keyboardHeight + 20),
                enableSuggestions: true,
                keyboardType: fieldType == TextFieldType.phone
                    ? TextInputType.phone
                    : keyboardType ?? TextInputType.text,
                onChanged: onChanged,
                style: style ??
                    Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.w500),
                inputFormatters: textInputFormatters,
                decoration: InputDecoration(
                  fillColor: fillColor ?? Colors.white,
                  filled: true,
                  focusColor: fillColor,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: enabledBorder ?? BorderRadius.circular(10),
                      borderSide: borderSide ?? BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: focusedBorder ?? BorderRadius.circular(10),
                      borderSide: borderSide ?? BorderSide.none),
                  contentPadding: contentPadding,
                  errorMaxLines: 6,
                  prefixIcon: pIcon,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4),
                    child: sIcon,
                  ),
                  hintText: hint,
                  hintStyle: hintstyle,
                ),
                validator: (val) {
                  if (fieldType == TextFieldType.refferal) return null;
                  if (val == null) return 'Invalid input';
                  if (validator == null) {
                    if (fieldType == TextFieldType.bvn) {
                      if (val.isEmpty) {
                        return 'Field cannot be empty';
                      } else if (val.trim().isEmpty) {
                        return "Field cannot be empty";
                      } else if (val.length < 11) {
                        return 'Invalid Entry';
                      } else if (int.tryParse(val) == null) {
                        return 'Invalid entry';
                      }
                      return null;
                    } else if (fieldType == TextFieldType.accountNo) {
                      if (val.isEmpty) {
                        return 'Field cannot be empty';
                      } else if (val.trim().isEmpty) {
                        return "Field cannot be empty";
                      } else if (val.length < 10) {
                        return 'Invalid Entry';
                      } else if (int.tryParse(val) == null) {
                        return 'Invalid entry';
                      }
                      return null;
                    } else if (fieldType == TextFieldType.pin) {
                      if (val.isEmpty) {
                        return 'Field cannot be empty';
                      } else if (val.trim().isEmpty) {
                        return "Field cannot be empty";
                      } else if (val.length < 4) {
                        return 'Invalid Entry';
                      } else if (int.tryParse(val) == null) {
                        return 'Invalid entry';
                      }
                      return null;
                    } else if (fieldType == TextFieldType.phone) {
                      if (val.isEmpty || val.trim().isEmpty) {
                        return 'Field must not be empty';
                      } else if (val.length < 11) {
                        return 'Invalid entry';
                      } else if (int.tryParse(val.replaceAll('+', '')) ==
                          null) {
                        return 'Invalid entry';
                      }
                      return null;
                    } else {
                      if (validate) {
                        if (val.isEmpty && (fieldType != TextFieldType.pin)) {
                          return "Field cannot be empty";
                        } else if (val.trim().isEmpty) {
                          return "Field cannot be empty";
                        } else if (fieldType == TextFieldType.amount) {
                          if (double.tryParse(val.replaceAll(',', '')) ==
                              null) {
                            return 'Enter a valid amount';
                          } else if (double.tryParse(
                                  val.replaceAll(',', ''))! <=
                              0) {
                            return 'Enter a valid amount';
                          }
                        } else if (fieldType == TextFieldType.email) {
                          bool isValidEmail = RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(val);
                          return isValidEmail
                              ? null
                              : "Please provide a valid email address";
                        }  else if (fieldType == TextFieldType.nin) {
                          if (val.isEmpty || val.trim().isEmpty) {
                            return 'Field must not be empty';
                          } else if (val.length < 11) {
                            return 'Invalid entry';
                          } else if (int.tryParse(val) == null) {
                            return 'Invalid entry';
                          }
                          return null;
                        }
                      }

                      return null;
                    }
                  } else {
                    validator!(val);
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    // Object initialValue,
    String hintText,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    obscureText = false,
    required Function onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      cursorColor: Colors.red,
      decoration: fieldDecoration(
        context,
        hintText,
        suffixIcon: suffixIcon!, prefixIcon: prefixIcon!,
      ),
      focusNode: focusNode,
      style: const TextStyle(fontFamily: 'Baloo Da 2'),
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (String value) {
        onChanged(value);
      },
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(6),
      hintText: hintText,
      hintStyle: const TextStyle(
          fontSize: 14.0,
          fontFamily: 'Baloo Da 2',
          fontWeight: FontWeight.normal,
          color: Colors.black87),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: const OutlineInputBorder(
        borderSide:  BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget fieldLabelValue(BuildContext context, String labelName) {
    return FormHelper.textInput(
      context, 
      labelName, 
      // "",
      (value) => {}, 
      onValidate: (value) {
        return null;
      },
      readOnly: true,
    );
  }

  static Widget saveButton(String buttonText, Function onTap,
      {String? color, String? textColor, bool? fullWidth}) {
        FocusNode focusNode = FocusNode();
        focusNode.unfocus();
    return SizedBox(
      height: 50.0,
      width: 350,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Colors.red,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
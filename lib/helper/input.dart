import 'package:flutter/material.dart';
import 'package:tautan_app/helper/config.dart';

Widget inputText(
    String hint, TextInputType type, TextEditingController controller) {
  return TextFormField(
    keyboardType: type,
    controller: controller,
    decoration: InputDecoration(
        alignLabelWithHint: true,
        // hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(color: Config.textBlack),
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.primary)),
        border: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.primary))),
  );
}

Widget inputTextWithMax(String hint, TextInputType type,
    TextEditingController controller, int line) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    maxLines: line,
    decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(color: Config.textBlack),
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.textGrey)),
        border: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.primary))),
  );
}

Widget dropDownBorder(String hint, List item, onChanged, value) {
  return DropdownButtonFormField(
    items: item,
    onChanged: onChanged,
    value: value,
    decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(color: Config.textBlack),
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.textGrey)),
        border: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.primary))),
  );
}

Widget inputPassword(String label, TextEditingController controller,
    TextInputType type, String hint, bool obsecure, onPress) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    obscureText: obsecure,
    controller: controller,
    decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: onPress,
          icon: obsecure
              ? Icon(
                  Icons.visibility_off,
                  color: Config.textGrey,
                )
              : Icon(
                  Icons.visibility,
                  color: Config.textGrey,
                ),
        ),
        alignLabelWithHint: true,
        // hintText: label,
        labelText: label,
        labelStyle: TextStyle(color: Config.textBlack),
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.textGrey)),
        border: OutlineInputBorder(
            borderSide: new BorderSide(color: Config.textGrey))),
  );
}

Widget roundedInput(TextEditingController controller, method) {
  return new TextField(
    controller: controller,
    decoration: new InputDecoration(
        suffixIcon: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(4),
            width: 40,
            // width: 35,
            // height: 35,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Config.primary),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Config.textWhite,
              ),
              onPressed: method,
            )),
        contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0),
        border: new OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        filled: true,
        hintStyle: new TextStyle(color: Colors.black38),
        hintText: "Type in your text",
        fillColor: Colors.white70),
  );
}

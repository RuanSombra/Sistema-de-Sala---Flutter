import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';

InputDecoration formDecoracao(
  String? text,
  IconButton? suffixicon,
  Icon? prefixicon,
) {
  return InputDecoration(
    hintText: text,
    hintStyle: TextStyle(color: cinzaEscuro, fontSize: 15),
    suffixIcon: suffixicon,
    suffixIconColor: azulEscuro,
    prefixIcon: prefixicon,
    prefixIconColor: azulEscuro,
    focusColor: cinzaEscuro,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: azulEscuro, width: 2.7),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: azulEscuro, width: 2),
    ),
  );
}

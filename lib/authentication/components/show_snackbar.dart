import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String mensagem,
  required bool isErro,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(mensagem),
    backgroundColor: isErro ? Colors.green : Colors.red,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

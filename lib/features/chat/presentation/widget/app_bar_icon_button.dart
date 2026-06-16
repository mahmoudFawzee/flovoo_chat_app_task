import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final void Function()? onPressed;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: icon);
  }
}

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String btName;
  final Icon? icon;
  final Color bgcolor;
  final TextStyle? textStyle;
  final VoidCallback? callback;

  const MyButton({
    super.key,
    required this.btName,
    this.icon,
    this.bgcolor = Colors.pink,
    this.textStyle,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(bgcolor), // Changed here
        foregroundColor: WidgetStateProperty.all(Colors.white), // Changed here
        shadowColor: WidgetStateProperty.all(bgcolor), // Changed here
        elevation: WidgetStateProperty.all(8), // Changed here
        shape: WidgetStateProperty.all(
          // Changed here
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
        padding: WidgetStateProperty.all(
          // Changed here
          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        overlayColor: WidgetStateProperty.all(
          bgcolor.withValues(alpha: 0.2), // Correct method name
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                const SizedBox(width: 8),
                Text(btName, style: textStyle),
              ],
            )
          : Text(btName, style: textStyle),
    );
  }
}

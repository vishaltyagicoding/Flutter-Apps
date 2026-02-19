import 'package:flutter/material.dart';

class TextFeilds {
  Widget makeTextField({
    required String text,
    required TextEditingController control,
    required icon,
    required textInnputType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: TextField(
        keyboardType: textInnputType,
        controller: control,

        decoration: InputDecoration(
          hintText: text, // Changed from 'hint' to 'hintText'
          labelText: text, // Optional: Shows label above the field
          prefix: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(width: 2, color: Colors.deepOrange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(width: 1, color: Colors.pink),
          ),
        ),
      ),
    );
  }
}

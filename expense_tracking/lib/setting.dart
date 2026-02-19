import 'package:expense_tracking/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: Consumer<ThemeProvider>(
        builder: (_, provider, __) {
          return SwitchListTile.adaptive(
            title: Text("Dark Mode"),
            subtitle: Text("Change Theme mode here"),
            value: provider.mode,
            onChanged: (value) {
              provider.updateTheme(mode: value);
            },
          );
        },
      ),
    );
  }
}

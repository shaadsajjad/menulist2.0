import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    var providers=Provider.of<Providers>(context);

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Text("Mode"),
            Switch(value: providers.isChanged, onChanged: (value){
              providers.updateTheme(data: value);
              //value=!light;

            })
          ],
        )
      ),
    );
  }
}

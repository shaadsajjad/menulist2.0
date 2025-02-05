import 'package:bucketleaf/Screen/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context)=> Providers(),
      child:  MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Providers>(context,listen: false).getTheme();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var providers=Provider.of<Providers>(context);
    return MaterialApp(

      theme:providers.isChanged? ThemeData.dark(useMaterial3: true):ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    home:Mainscreen(),
    );
  }
}

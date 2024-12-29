import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bucketleaf/display.dart';
class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<dynamic>menulist=[];
  Future<void> getdata() async{
    Response response= await Dio().get('https://bangla-bhai-restaurent-server.vercel.app/menu');

    setState(() {
      menulist=response.data;
    });
    print(menulist);



  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getdata();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket list"),
        centerTitle: true,

    ),
      body:ListView.builder(
          itemCount: menulist.length,
          itemBuilder: (BuildContext context,int index) {
        return ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Display(menulist: menulist,index: index);
            }));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(menulist[index]["image"]??""),
          ),
          title: Text(menulist[index]["name"]?? ""),
          subtitle: Text(menulist[index]["category"]?? ""),
          trailing: Text("\$ ${menulist[index]["price"].toString()?? ""}"),

        );
      }
      )
    );
  }
}

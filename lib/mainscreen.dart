import 'dart:ui';

import 'package:bucketleaf/additem.dart';
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
  List<dynamic> menulist = [];
  Future<void> getdata() async {
    isLoading = true;
    try {
      Response response = await Dio().get(
          'https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf.json');
      setState(() {
        menulist = response.data;
      });
    } catch (e) {
      print(e);
    }
    isLoading = false;
    print(menulist);
  }

  bool isLoading = false;
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Additem(index: menulist.length)));

      },
      child: Icon(Icons.add)),

        appBar: AppBar(
          title: Text("Bucket list"),
          centerTitle: true,
        ),

        body: RefreshIndicator(
          onRefresh: () async {
            getdata();
          },
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : ListView.builder(
                  itemCount: menulist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (menulist[index] is Map)
                        ? ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Display(
                                    menulist: menulist, index: index, getData: getdata);
                              }));
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(menulist[index]?["image"] ?? ""),
                            ),
                            title: Text(menulist[index]?["name"] ?? ""),
                            subtitle: Text(menulist[index]?["category"] ?? ""),
                            trailing: Text(
                                "\$ ${menulist[index]?["price"].toString() ?? ""}"),
                          )
                        : SizedBox();
                  }),
        ));
  }
}

import 'dart:ui';

import 'package:bucketleaf/Screen/additemScreen.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bucketleaf/Screen/displayScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/provider.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  TextEditingController search = TextEditingController();
  List<dynamic> menulist = [],searchlist=[];
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

  bool searche = false,see=false;

  bool isLoading = false;
  Future<void>setMode({required bool value}) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Mode', value);

  }
  getMode() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value= prefs.getBool('Mode');


  }
  @override
  void initState() {
   // var providers=Provider.of<Providers>(context);
    // TODO: implement initState
    super.initState();
    setState(() {
      getdata();
     // providers.updateTheme(data:getMode());
    });
  }
  Widget showList(menuliste){
    if(menuliste.isEmpty) {
      return Center(child: Text("No related item"));
    }
    else {
  return ListView.builder(
      itemCount: menuliste.length,
      itemBuilder: (BuildContext context, int index) {
        return (menuliste[index] is Map)
            ? ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return Display(
                      menulist: menuliste,
                      index: index,
                      getData: getdata);
                }));
          },
          leading: CircleAvatar(
            backgroundImage:
            NetworkImage(menuliste[index]?["image"] ?? ""),
          ),
          title: Text(menuliste[index]?["name"] ?? ""),
          subtitle: Text(menuliste[index]?["category"] ?? ""),
          trailing: Text(
              "\$ ${menuliste[index]?["price"].toString() ?? ""}"),
        )
            : SizedBox();
      });
  }
  }
  @override
  Widget build(BuildContext context) {
    var providers=Provider.of<Providers>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Additem(index: menulist.length)));
          },
          child: Icon(Icons.add)),
      appBar: searche?
      AppBar(
        leading: InkWell
          (
          onTap: (){
            see=false;
            searche=false;
            setState(() {

            });
          },
            child: Icon(Icons.arrow_back_outlined)),
        title: TextField(
          controller: search,
          decoration: InputDecoration(
            hintText: "Seach by Category"
          ),
        ),
        actions: [
          ElevatedButton(onPressed: (){
            if(search.text.isNotEmpty) {
            setState(() {


              print("success $searchlist");
              searchlist=menulist.where((element)=>element?["category"]==search.text).toList();
             print("success $searchlist");
              see=true;
              search.text="";
            });
            }


          }, child: Text("Search"))
        ],
      )
      :AppBar(
           title: Text("Bucket list"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  setState(() {
                    searche = true;
                  });

                },
                child: Icon(Icons.search)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: (){
                 showModalBottomSheet(context: context, builder: (context){
                   return Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: Container(
                       height: 60,
                       child: Row(
                         children: [

                           Text("Mode",
                             style: TextStyle(
                                 fontSize: 28
                             ),),
                           SizedBox(width: 10),
                           Switch(value: providers.isChanged, onChanged: (value){
                             providers.updateTheme(data: value);
                             setMode(value: value);

                             //value=!light;

                           })
                         ],
                       ),
                     ),
                   );
                 });

                },
                child: Icon(Icons.settings)),
          )
        ],
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
            : see?showList(searchlist):showList(menulist)
        // ],
      ),
      // ),
    );
  }
}

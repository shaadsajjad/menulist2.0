import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Display extends StatefulWidget {
  List<dynamic> menulist;
  int index;
  Function getData;
  Display(
      {super.key,
      required this.menulist,
      required this.getData,
      required this.index});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  TextEditingController update = TextEditingController();
  var updateitem = GlobalKey<FormState>();
  Future<void> deleteItem() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
          "https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf/${widget.index}.json");
    } catch (e) {
      print('error');
    }
    Navigator.pop(context);
    widget.getData();
  }

  Future<void> updateItem(item) async {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "You want to update $item of this item, Please Write a new $item of this item"),
            content: TextField(
              key: updateitem,
              controller: update,


            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              InkWell(
                  onTap: () async{
                   if(update.text==null || update.text.isEmpty ) {
                     Navigator.pop(context);
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text("write something to update"),
                        );
                      });
                    }
                   else{
                     Navigator.pop(context);
                     Map<String, dynamic> data = {
                       "$item": update.text,
                     };
                     try {
                       Response response = await Dio().patch(
                           "https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf/${widget.index}.json",data: data);
                     } catch (e) {
                       print('error');
                     }
                     setState(() {

                     });
                     widget.getData;
                   }
                  },
                  child: Text("Update"))
            ],
          );
        });
    //
    // Navigator.pop(context);
    // widget.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(onSelected: (value) {
              if (value == 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure you want to delete?"),
                        actions: [
                          InkWell(onTap: deleteItem, child: Text("Yes")),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text("No"))
                        ],
                      );
                    });
              }
              if (value == 2) {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          height: 270,
                          child: Column(
                            children: [
                              Text(
                                "Which one you want to update?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  updateItem("name");
                                },
                                child: Text(
                                  "Name",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                          InkWell(
                            onTap: () {
                              updateItem("recipe");
                            },
                             child: Text(
                                "Recipe",
                                style: TextStyle(fontSize: 18),
                              ),
                          ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: (){
                                  updateItem("image");
                                },
                                child: Text(
                                  "Image",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: (){
                                  updateItem("cateory");
                                },
                                child: Text(
                                  
                                  "Category",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: (){
                                  updateItem("price");
                                },
                                child: Text(
                                  "Price",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem(value: 1, child: Text("Delete")),
                PopupMenuItem(value: 2, child: Text("Update"))
              ];
            })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                ClipRect(
                    child: Image.network(
                  widget.menulist[widget.index]["image"],
                  fit: BoxFit.cover,
                )),
                SizedBox(height: 10),
                Text(
                  widget.menulist[widget.index]["name"],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
                SizedBox(height: 5),
                Text(
                  widget.menulist[widget.index]["recipe"],
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Category:- ${widget.menulist[widget.index]["category"]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Price:- \$ ${widget.menulist[widget.index]["price"].toString()}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Display extends StatefulWidget {
  List<dynamic>menulist;
  int index;
   Display({super.key,required this.menulist,required this.index});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                ClipRect(child: Image.network(widget.menulist[widget.index]["image"],
                fit: BoxFit.cover,

                )),
                SizedBox(height: 10),
                Text(widget.menulist[widget.index]["name"],style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25
                ),),
                SizedBox(height: 5),
                Text(widget.menulist[widget.index]["recipe"],style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category:- ${widget.menulist[widget.index]["category"]}",
                    style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w500
                    ),
                    ),
                    Text("Price:- \$ ${widget.menulist[widget.index]["price"].toString()}",
                      style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),),


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

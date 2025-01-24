import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Additem extends StatefulWidget {
  int index;
   Additem({super.key , required this.index});

  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  TextEditingController addName=TextEditingController();
  TextEditingController addRecipe=TextEditingController();
  TextEditingController addImage=TextEditingController();
  TextEditingController addCategory=TextEditingController();
  TextEditingController addPrice=TextEditingController();
  var additem=GlobalKey<FormState>();


  Future<void> addItem(name,recipe,image,category,price) async{
    Map<String,dynamic>data={
      "name": name,
      "recipe": recipe,
      "image": image,
      "category": category,
      "price": price
    };
    try{
      Response response=await Dio().patch("https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf/${widget.index}.json",data: data);
    }catch(e){
      print(e);
    }
    Navigator.pop(context);
    //widget.getData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
appBar: AppBar(
  title: Text("Add Item"),
  centerTitle: true,
),
      body: Form(

          key: additem,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: addName,
              validator: (value){
                if(value==null || value.isEmpty){
                  return "Please enter name";
                }

              },
            decoration: InputDecoration(
              labelText: "Enter name"
            ),
            ),
          SizedBox(height: 20,),
          TextFormField(
            controller: addRecipe,
            validator: (value){
              if(value==null || value.isEmpty){
                return "Please enter recipe";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Enter recipe"
            ),
            ) ,
            SizedBox(height: 20,),
            TextFormField(
              controller: addImage,
              validator: (value){
                if(value==null || value.isEmpty){
                  return "Please enter image url";
                }
              },
            decoration: InputDecoration(
              labelText: "Image URL"
            ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: addCategory,
              validator: (value){
                if(value==null || value.isEmpty){
                  return "Please enter category";
                }

              },
            decoration: InputDecoration(
              labelText: "Category"
            ),
            ), SizedBox(height: 20,),
            TextFormField(
              controller: addPrice,
            validator: (value){
                if(value==null || value.isEmpty){
                  return "Please enter price";
                }
            },
            decoration: InputDecoration(
              labelText: "Enter price"
            ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              if(additem.currentState!.validate()) {
                addItem(addName.text, addRecipe.text, addImage.text, addCategory.text, addPrice.text);

              }
            }, child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 150),
              child: Text("Add",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
              ),
              ),
            ),


           )
          ],
        ),
      )),
    );
  }
}

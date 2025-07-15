import 'package:bucketleaf/Screen/additemScreen.dart';
import 'package:dio/dio.dart';
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
  List<MapEntry<String, dynamic>> menulist = [];
  List<MapEntry<String, dynamic>> searchlist = [];

  bool searche = false, see = false;
  bool isLoading = false;

  Future<void> getdata() async {
    setState(() => isLoading = true);
    try {
      Response response = await Dio().get(
          'https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf.json');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        setState(() {
          menulist = data.entries.toList();
        });
      } else {
        print("Unexpected data format: ${data.runtimeType}");
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> setMode({required bool value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Mode', value);
  }

  getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('Mode');
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Widget showList(List<MapEntry<String, dynamic>> menuliste) {
    if (menuliste.isEmpty) {
      return Center(child: Text("No related item"));
    } else {
      return ListView.builder(
        itemCount: menuliste.length,
        itemBuilder: (BuildContext context, int index) {
          final item = menuliste[index].value;
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Display(
                    menulist: menuliste,
                    index: index,
                    getData: getdata,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item["image"] ?? ""),
            ),
            title: Text(item["name"] ?? ""),
            subtitle: Text(item["category"] ?? ""),
            trailing: Text("\$ ${item["price"].toString()}"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var providers = Provider.of<Providers>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Additem(index: menulist.length)));
        },
        child: Icon(Icons.add),
      ),
      appBar: searche
          ? AppBar(
        leading: InkWell(
          onTap: () {
            see = false;
            searche = false;
            setState(() {});
          },
          child: Icon(Icons.arrow_back_outlined),
        ),
        title: TextField(
          controller: search,
          decoration: InputDecoration(hintText: "Search by Category"),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                if (search.text.isNotEmpty) {
                  setState(() {
                    searchlist = menulist
                        .where((entry) =>
                    entry.value["category"] == search.text)
                        .toList();
                    see = true;
                    search.text = "";
                  });
                }
              },
              child: Text("Search"))
        ],
      )
          : AppBar(
        title: Text("Bucket List"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                searche = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          Text(
                            "Mode",
                            style: TextStyle(fontSize: 28),
                          ),
                          SizedBox(width: 10),
                          Switch(
                            value: providers.isChanged,
                            onChanged: (value) {
                              providers.updateTheme(data: value);
                              setMode(value: value);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => getdata(),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : see
            ? showList(searchlist)
            : showList(menulist),
      ),
    );
  }
}

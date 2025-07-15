import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Display extends StatefulWidget {
  final List<MapEntry<String, dynamic>> menulist;
  final int index;
  final Function getData;

  const Display({
    super.key,
    required this.menulist,
    required this.getData,
    required this.index,
  });

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  TextEditingController update = TextEditingController();

  Future<void> deleteItem() async {
    Navigator.pop(context); // Close confirmation dialog
    try {
      final firebaseKey = widget.menulist[widget.index].key;
      await Dio().delete(
        "https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf/$firebaseKey.json",
      );
    } catch (e) {
      print('Delete error: $e');
    }
    widget.getData(); // Refresh list
    Navigator.pop(context); // Close Display page
  }

  Future<void> updateItem(String field) async {
    Navigator.pop(context); // Close bottom sheet
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update $field"),
          content: TextField(
            controller: update,
            decoration: InputDecoration(hintText: "Enter new $field"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (update.text.trim().isEmpty) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Please enter a value to update."),
                    ),
                  );
                  return;
                }

                final firebaseKey = widget.menulist[widget.index].key;
                try {
                  await Dio().patch(
                    "https://bucketleaf-eb7e8-default-rtdb.firebaseio.com/bucketleaf/$firebaseKey.json",
                    data: {
                      field: update.text.trim(),
                    },
                  );
                } catch (e) {
                  print('Update error: $e');
                }

                update.clear();
                widget.getData();
                Navigator.pop(context); // Close alert dialog
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.menulist[widget.index];
    final item = entry.value;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(item["name"] ?? "No Name"),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: deleteItem,
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("No"),
                        ),
                      ],
                    ),
                  );
                } else if (value == 2) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Which field do you want to update?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            ...["name", "recipe", "image", "category", "price"]
                                .map(
                                  (field) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                  onTap: () => updateItem(field),
                                  child: Text(
                                    field[0].toUpperCase() + field.substring(1),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 1, child: Text("Delete")),
                PopupMenuItem(value: 2, child: Text("Update")),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item["image"] ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                ),
              ),
              SizedBox(height: 10),
              Text(
                item["name"] ?? "No Name",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              SizedBox(height: 5),
              Text(
                item["recipe"] ?? "No recipe provided",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category: ${item["category"] ?? "N/A"}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Price: \$${item["price"]?.toString() ?? "0"}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

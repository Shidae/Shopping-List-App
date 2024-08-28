import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:http/http.dart' as http;
import '../models/grocery_item.dart';
import 'dart:convert'; // encode data type Map into json formatted text

// models how the screen accept inputs
class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItem();
  }
}

class _NewItem extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = "";
  var _enteredQuantity = 1;
  var _selectedCategory =
      categories[Categories.vegetables]; // Map<Category, categories>

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      // can't be null
      _formKey.currentState!.save();
      final url = Uri.https( // generate http
          // remove the http
          "shopping-list-97966-default-rtdb.asia-southeast1.firebasedatabase.app",
          "shopping_list.json"); // create a project node as json files
      final response = await http.post(url,// url, to which the request should be sent
          headers: {// how the data sent to the url will be formatted
            'Content_Type': 'application/json',
          },
          body: json.encode({// which data should be attached to the outgoing request
            // firebase generates unique id, so id is not required
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory!.foodTitle
          }));
      // response.statusCode;
      print(response.statusCode);

      if(!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _enteredName,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  // value entered by the user
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 2 ||
                      value.trim().length > 50) {
                    return 'Enter at least 2 - 50 words';
                  } // otherwise, no need for else
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                // to align the form underline
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        initialValue: _enteredQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) ==
                                  null || // if alphabet returns null
                              int.tryParse(value)! <= 0) {
                            return 'Only positive numbers are allowed';
                          } // otherwise, no need for else
                          return null;
                        },
                        onSaved: (value) {
                          _enteredQuantity = int.parse(value!);
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // .entries is method for Map which gives an Iterable containing key value pairs
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory, // default dropdown value
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              // overall Category object should be assigned to each of the dropdown item
                              value: category.value,
                              // (foodTitle, color) specified by user
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(category.value.foodTitle)
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              _selectedCategory = value!;
                            },
                          );
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem, // trigger the validation message
                    child: const Text("Save"),
                  ),
                ],
              )
              // instead of TextField, Form has more options
            ],
          ),
        ),
      ),
    );
  }
}

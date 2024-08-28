import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = []; // to append each item object here

  void _addItem() async {
    // waiting for NewItem screen to pass GroceryItem object
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("Start adding groceries items +"));

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id), // Ensure each item has a unique key
          background: Container( // if swiping from left
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container( // if swiping from right
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              _removeItem(_groceryItems[index]);
            });
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            // indicator that comes before the title
            leading: Container(
              width: 25,
              height: 24,
              color: _groceryItems[index]
                  .category
                  .color, // access the color property of category argument
            ),
            // indicator that comes after the title
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add_shopping_cart_rounded),
            ),
          ],
          leading: const Icon(
            Icons.shopping_cart_outlined,
          ),
          title: Text(
            "Let's do some shopping!",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        // render items which are only visible especially for long list
        body: content);
  }
}

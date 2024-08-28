import 'package:flutter/material.dart';

enum Categories { // for each of these key, value food and color are assigned
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class GroceryItem {
  const GroceryItem( {required this.id, required this.name,
  required this.quantity, required this.category});

  final String id;
  final String name;
  final int quantity;
  final Category category;
}

class Category {
  // const Category({required this.food, required this.color});
  // in categories.dart, the data is passed by position, not by name
  const Category(this.foodTitle, this.color);
  final String foodTitle;
  final Color color;
}
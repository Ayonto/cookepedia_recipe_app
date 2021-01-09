import 'package:flutter/material.dart';
import 'package:cookepedia_recipe_app/homepage.dart';

void main() {
  runApp(Cookepedia());
}

class Cookepedia extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

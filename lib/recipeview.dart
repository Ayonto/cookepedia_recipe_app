import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cookepedia_recipe_app/recipemodel.dart';


class RecipeView extends StatefulWidget {
  final String mealId;

  RecipeView({this.mealId});

  @override
  _RecipeViewState createState() => _RecipeViewState();

}

class _RecipeViewState extends State<RecipeView> {
  String mealId;
  List<RecipeModel> theRecipe = new List();
  RecipeModel model = new RecipeModel();
  bool _loading = false;


  // ignore: missing_return
  void _fetchRandom() async {

    setState(() {
      _loading = true;
    });
    
    var response = await http.get("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId");
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    RecipeModel recipeModel = new RecipeModel();
    recipeModel = RecipeModel.forMap(jsonData["meals"][0]);
    setState(() {
      model = recipeModel;
      _loading = false;

    });

  }
  
  @override
  void initState() {
    super.initState();
    mealId = widget.mealId;
    _fetchRandom();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9aa89),
      body: _loading
          ? Center(
            child: CircularProgressIndicator(),
          )
          : ListView(

          children: [

            Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
            child: Container(

              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              
    

              child: Text(model.mealName, style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500, fontFamily: "Amaranth", color: Colors.black.withOpacity(0.9))),


              ),
            ),


            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category-${model.mealCategory}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Alata",
                    ),
                  ),
                  Text(
                    "Area-${model.mealArea}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Alata",
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width+10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: NetworkImage(model.mealThumb),
                    fit: BoxFit.fill,
                  ),
                  
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(15.0),

              child: Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Alata",
                ),
              ),
              
            ),

            Padding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
              
                decoration: BoxDecoration(
                ),
                child: Column(
                  children: List.generate(model.mealIngredient.length, (index) {
                    return _IngredientTile(ingredientList: model.mealIngredient, measureList: model.mealMeasure, index: index);
                  }),
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(15.0),

              child: Text(
                "Instruction",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Alata",
                ),
              ),
              
            ),

            Padding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xffffceae).withOpacity(0.6),
                ),
                child: Text(
                  model.mealInstructions,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Alata",
                  ),
                ),
              ),
            ),

            // white line
            
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.white,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Center(
                child: Container(
                  height: 2.0,
                  width: MediaQuery.of(context).size.width/1.2,
                  color: Colors.white,
                ),
              ),
            ),

            // thanks from cookepedia

            Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Text(
                  "Thanks from Cookepedia",
                  style: TextStyle(
                    fontFamily: "Pacifico",
                    fontSize: 16.0,
                    

                  ),
                ),

              ),
            ),

          ],
        ),
    );
  }
}


class _IngredientTile extends StatelessWidget {
  final List ingredientList;
  final List measureList;
  final int index; 
  _IngredientTile({this.ingredientList, this.measureList, this.index});

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.width/3,
            width: MediaQuery.of(context).size.width/3,
            decoration: BoxDecoration(
              color: Color(0xffffefd6),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
              image: DecorationImage(
                image: NetworkImage("https://www.themealdb.com/images/ingredients/${ingredientList[index]}.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          
          Flexible(

            child: Container(
              padding: EdgeInsets.all(15.0),
              
              
              decoration: BoxDecoration(
                color: Color(0xffFFDBD6).withOpacity(0.3),
                borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),

              ),
              height: MediaQuery.of(context).size.width/3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${ingredientList[index]} - ${measureList[index]}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Alata",
                  ),
                ),
              ),

              
            ),
          ),

          
        ],
      ),
      
    );
  }
}

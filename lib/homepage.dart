import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cookepedia_recipe_app/recipemodel.dart';
import 'package:cookepedia_recipe_app/searchview.dart';
import 'package:cookepedia_recipe_app/recipeview.dart';
import 'package:cookepedia_recipe_app/connectivity.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // check internet connection
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  
  TextEditingController textEditingController = new TextEditingController();
  List<RecipeModel> randomRecipe = new List();
  List<RecipeModel> deseartRecipe = new List();
  List<RecipeModel> seafoodRecipe = new List();
  List<RecipeModel> veganRecipe = new List();
  bool _loading = false;
  int _fetchValue = 0;

  void _fetchRandom() async {
    setState(() {
      _loading = true;
    });

    var randomResponse = await http.get("https://www.themealdb.com/api/json/v1/1/random.php");
    Map<String, dynamic> randomData = jsonDecode(randomResponse.body);

    randomData["meals"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element);
      randomRecipe.add(recipeModel);
    });



    setState(() {
      _loading = false;
      _fetchValue += 1;
    });
    
  }

  void _fetchDeseart() async {
    setState(() {
      _loading = true;
    });

    var deseartResponse = await http.get("https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert");
    Map<String, dynamic> deseartData = jsonDecode(deseartResponse.body);

    deseartData["meals"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element);
      deseartRecipe.add(recipeModel);
    });

    setState(() {
      _loading = false;
    });
    
  }

  void _fetchSeafood() async {
    setState(() {
      _loading = true;
    });

    var seafoodResponse = await http.get("https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood");
    Map<String, dynamic> seafoodData = jsonDecode(seafoodResponse.body);

    seafoodData["meals"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element);
      seafoodRecipe.add(recipeModel);
    });

    setState(() {
      _loading = false;
    });
    
  }


  void _fetchVegan() async {
    setState(() {
      _loading = true;
    });

    var deseartResponse = await http.get("https://www.themealdb.com/api/json/v1/1/filter.php?c=Vegetarian");
    Map<String, dynamic> deseartData = jsonDecode(deseartResponse.body);

    deseartData["meals"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element);
      veganRecipe.add(recipeModel);
    });

    setState(() {
      _loading = false;
    });
    
  }



  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

  }

  
  
  @override
  Widget build(BuildContext context) {
    String status;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        status = "Offline";
        break;
      case ConnectivityResult.mobile:
        status = "Online";
        break;
      case ConnectivityResult.wifi:
        status = "Online";
    }



    if(status == "Offline"){
      return Scaffold(
        backgroundColor: Color(0xfff9aa89),
        body: Center(
          child: Text(
            "Oops no Internet connection",
            style: TextStyle(
              fontFamily: "Amaranth",
              fontSize: 24.0,
            ),
          ),
        ),
      );
    }

    else {
      if(_fetchValue < 45) {
        _fetchRandom();
        _fetchDeseart();
        _fetchSeafood();
        _fetchVegan();
      }
      return Scaffold(
        backgroundColor: Color(0xfff9aa89),
        body:ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "SEARCH FOR",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 27.0, color: Colors.black, fontFamily: "Alata"),  
                      ),

                      Text(
                        "RECIPES",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 27.0, color: Colors.black, fontFamily: "Alata"),

                      ),

                    ],
                  ),

                  // app logo

                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Color(0xffAA89F9),
                        image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                      ),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "Try something new",
                          border: InputBorder.none,
                          fillColor: Colors.grey.withOpacity(0.5),
                          prefix: Padding(padding: EdgeInsets.only(left: 10.0)),
                        ),
                      ),
                    ),
                  ),
                ),

                // search icon

                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: InkWell(
                    onTap: () async {
                      if(textEditingController.text.isNotEmpty){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchView(searchTerm: textEditingController.text)));
                      }

                    },

                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                        color: Colors.white.withOpacity(0.5),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 32,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      
                    ),
          
                  ),
                ),
              ],
            ),

            // Recommended text

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Amaranth",
                    ),
                  ),

                  Text(
                    "swipe for more",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Alata",
                    ),
                  ),

                ],
              ),
              
              
            ),

            // Recommended List

            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                padding: EdgeInsets.all(15.0),
                width: double.infinity,
                height: MediaQuery.of(context).size.width-10,
                decoration: BoxDecoration(
                  color: Color(0xffffceae),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0), topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(randomRecipe.length, (index) {

                    return RecommandedTile(mealName: randomRecipe[index].mealName, imgUrl: randomRecipe[index].mealThumb, mealID: randomRecipe[index].idMeal, forGrid: false);
                  }),
                
                ),
              ),
            ),


            // what's for deseart

            Padding(
              padding: EdgeInsets.only(top:10.0, left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "What's for Dessert?",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "LobsterTwo",
                    ),
                  ),

                  Text(
                    "swipe for more",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Alata",
                    ),
                  ),

                ],
              ),
            ),

            // Deseart List

            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width-10,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisSpacing: 0.0, maxCrossAxisExtent: 200.0, crossAxisSpacing: 15.0),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(deseartRecipe.length, (index) {

                    return RecommandedTile(mealName: deseartRecipe[index].mealName, imgUrl: deseartRecipe[index].mealThumb, mealID: deseartRecipe[index].idMeal, forGrid: true);
                  }),
                ),
              ),
            ),

            // Try seafood

            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Try Seafood",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: "Pacifico",
                    ),
                  ),

                  Text(
                    "swipe for more",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Alata",
                    ),
                  ),
                ],
              ),
            ),

            // seafood grid

            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width-10,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisSpacing: 0.0, maxCrossAxisExtent: 200.0, crossAxisSpacing: 15.0),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(seafoodRecipe.length, (index) {

                    return RecommandedTile(mealName: seafoodRecipe[index].mealName, imgUrl: seafoodRecipe[index].mealThumb, mealID: seafoodRecipe[index].idMeal, forGrid: true);
                  }),
                ),
              ),
            ),

            // For vegetarians


            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "For Vegetarians",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: "Pacifico",
                    ),
                  ),

                  Text(
                    "swipe for more",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Alata",
                    ),
                  ),

                ],
              ),
              
              
            ),

            // vegan list

            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width-10,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisSpacing: 0.0, maxCrossAxisExtent: 200.0, crossAxisSpacing: 15.0),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(veganRecipe.length, (index) {

                    return RecommandedTile(mealName: veganRecipe[index].mealName, imgUrl: veganRecipe[index].mealThumb, mealID: veganRecipe[index].idMeal, forGrid: true);
                  }),
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
}

class RecommandedTile extends StatefulWidget {
  final String mealName;
  final String imgUrl;
  final String mealID;

  final bool forGrid;


  RecommandedTile({this.mealName, this.imgUrl, this.mealID, this.forGrid});
  
  @override
  _RecommandedTileState createState() => _RecommandedTileState();
}

class _RecommandedTileState extends State<RecommandedTile> {
  String mealName;
  String imgUrl;
  String mealID;
  bool forGrid;

  void initState(){
    super.initState();
    mealName = widget.mealName;
    imgUrl = widget.imgUrl;
    mealID = widget.mealID;
    forGrid = widget.forGrid;

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(mealId: mealID,)));
        },
        child: Container(
          padding: EdgeInsets.all(15.0),

          width: MediaQuery.of(context).size.width - 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.black,
            image: DecorationImage(
              image: NetworkImage(imgUrl),
              fit: BoxFit.fill
            ),

          ),
          child: (forGrid == true)
               ? Text("")
               :
          
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              mealName,
              style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.w500, fontFamily: "Alata", color: Colors.white),
              
            ),
          ),
        
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:cookepedia_recipe_app/recipemodel.dart';
import 'package:cookepedia_recipe_app/homepage.dart';
import 'package:cookepedia_recipe_app/recipeview.dart';
import 'package:cookepedia_recipe_app/connectivity.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';



class SearchView extends StatefulWidget {
  final String searchTerm;

  SearchView({this.searchTerm});
  
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // check connection
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  
  String searchTerm;
  List<RecipeModel> recipies = new List();
  bool _loading = false;

  TextEditingController searchEditingController = new TextEditingController();

  void _search() async {

    setState(() {
      _loading = true;
    });

    var response = await http.get("https://www.themealdb.com/api/json/v1/1/search.php?s=$searchTerm");
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    if(jsonData["meals"] != null){
      jsonData["meals"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element);
      recipies.add(recipeModel);
      });
    } else{
      recipies = null;
    }
    setState(() {
      _loading = false;
    });

  }



  @override
  void initState() {
    super.initState();

    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    
    searchTerm = widget.searchTerm;
    _search();
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
            "No Internet connection",
            style: TextStyle(
              fontFamily: "Amaranth",
              fontSize: 24.0,
            ),
          ),
        ),
      );
    }

    else {

      return Scaffold(
        backgroundColor: Color(0xfff9aa89),
        body: _loading
            ? Center(
              child: CircularProgressIndicator(),
            )
            :
        Stack(    
          clipBehavior: Clip.hardEdge,
          children: [

            Container(
              
              child: (recipies==null)
              ? Center(
                child: Text(
                  "Oops no result for \"$searchTerm\"",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Amaranth",
                  ),
                ),
              )
              :
              ListView(  
                padding: EdgeInsets.only(top: 90),      
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                children: List.generate(recipies.length, (index) {
                  return RecipeTile(mealName: recipies[index].mealName, imgUrl: recipies[index].mealThumb, mealID: recipies[index].idMeal);
                }),
              ),
            ),

            SizedBox(height: 30),
            
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 25.0),
                  child: InkWell(
                    onTap: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.home, size: 32, color: Colors.white),
                        ],
                      ),
                      
                    ),
                  ),
                ),

                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left:10.0, top: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                      ),
                      child: TextField(
                        controller: searchEditingController,
                        decoration: InputDecoration(
                          hintText: "search",
                          border: InputBorder.none,
                          fillColor: Colors.grey.withOpacity(0.5),

                          prefix: Padding(padding: EdgeInsets.only(left: 10.0)),
                          
                        ),
                      ),

                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right:15.0, top: 25.0),
                  child: InkWell(
                    onTap: () async {
                      if(searchEditingController.text.isNotEmpty){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchView(searchTerm: searchEditingController.text)));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                        color: Colors.white.withOpacity(0.5),

                      ),

                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search, 
                            size: 32,
                            color: Colors.white
                          ),
                        ],
                      ),
                    ),
                  ), 
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}


class RecipeTile extends StatefulWidget {
  final String imgUrl;
  final String mealName;
  final String mealID;
  
  RecipeTile({this.mealName, this.imgUrl, this.mealID});
  
  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  String imgUrl;
  String mealName;
  String mealID;

  void initState(){
    super.initState();
    imgUrl = widget.imgUrl;
    mealName = widget.mealName;
    mealID = widget.mealID;
  }

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(mealId: mealID,)));
        },
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0, top: 15.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.fill),

          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              mealName,
              style: TextStyle(
                fontSize: 42.0,
                fontWeight: FontWeight.w500,
                fontFamily: "Alata",
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
        
      ),
    );
  }
}
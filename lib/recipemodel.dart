class RecipeModel {
  final String idMeal;
  final String mealThumb;
  final String mealName;
  final String mealCategory;
  final String mealArea; 
  final String mealInstructions;
  final List mealIngredient;
  final List mealMeasure;

  Map sliceMap(Map<String, dynamic> map, offset, limit) {

    return new Map.fromIterable(map.keys.skip(offset).take(limit),
      value: (k) => map[k]);
  }
  
  RecipeModel({this.idMeal, this.mealThumb, this.mealName, this.mealCategory, this.mealArea, this.mealInstructions, this.mealIngredient, this.mealMeasure});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        idMeal: parsedJson["idMeal"],
        mealThumb: parsedJson["strMealThumb"],
        mealName: parsedJson["strMeal"]);
  }

  factory RecipeModel.forMap(Map<String, dynamic> parsedJson){

    
    var ingredientMap = new Map.fromIterables(parsedJson.keys.skip(9).take(20), parsedJson.values.skip(9).take(20));

    var measureMap = new Map.fromIterables(parsedJson.keys.skip(29).take(20), parsedJson.values.skip(29).take(20));


    List ingredient = new List();
    List measure = new List();

    ingredientMap.forEach((k, v) {
      if(v!=''){
        if(v!=null)
          ingredient.add(v);
      }
        
    });


    measureMap.forEach((k, v) {
      if(v!=''){
        if(v!=null)
          measure.add(v);
      }

    });
    return RecipeModel(
      mealThumb: parsedJson["strMealThumb"],
      mealName: parsedJson["strMeal"],
      mealCategory: parsedJson["strCategory"],
      mealArea: parsedJson["strArea"],
      mealInstructions: parsedJson["strInstructions"],
      mealIngredient: ingredient,
      mealMeasure: measure
    );
  }

}
import 'dart:convert';
import 'package:uts_1202210285/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeSearchApi {
  static Future<List<Recipe>> searchRecipe(String query) async {
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/search', {
      "start": "0",
      "maxResult": "18",
      "maxTotalTimeInSeconds": "7200",
      "q": query,
      "allowedAttribute": "diet-lacto-vegetarian,diet-low-fodmap",
      "FAT_KCALMax": "1000"
    });

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "d6c1907447mshf1779fed9a8f244p147163jsnff0cc9ea717c",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List _temp = [];

      for (var i in data['feed']) {
        _temp.add(i['content']['details']);
      }

      return Recipe.recipesFromSnapshot(_temp);
    } else {
      throw Exception("Failed to load recipes");
    }
  }
}

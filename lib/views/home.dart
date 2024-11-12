import 'package:flutter/material.dart';
import 'package:uts_1202210285/models/recipe.api.dart';
import 'package:uts_1202210285/models/recipe.dart';
import 'package:uts_1202210285/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> _allRecipes; // Semua resep tanpa filter
  late List<Recipe> _filteredRecipes; // Resep hasil filter pencarian
  bool _isLoading = true;
  bool _isSearching = false; // Menandai apakah pencarian aktif atau tidak
  bool _isSortedByTime = false; // Menandai apakah hasil pencarian diurutkan berdasarkan waktu
  bool _isDescending = true; // Menentukan urutan filter (terlama ke tercepat atau sebaliknya)

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  // Fungsi untuk mendapatkan daftar resep populer
  Future<void> getRecipes() async {
    _allRecipes = await RecipeApi.getRecipe();
    setState(() {
      _filteredRecipes = _allRecipes; // Awalnya, tampilkan semua resep
      _isLoading = false;
    });
  }

  // Fungsi untuk melakukan pencarian lokal berdasarkan nama resep
  void _searchRecipes(String query) {
    final filtered = _allRecipes.where((recipe) {
      final recipeName = recipe.name.toLowerCase();
      final input = query.toLowerCase();
      return recipeName.contains(input); // Filter berdasarkan nama resep
    }).toList();

    setState(() {
      _filteredRecipes = filtered;
      _isSearching = query.isNotEmpty; // Aktifkan mode pencarian jika ada input
      if (_isSortedByTime) {
        sortByTime(); // Pastikan daftar tetap diurutkan berdasarkan waktu jika filter aktif
      }
    });
  }

  // Fungsi untuk mengurutkan daftar resep berdasarkan totalTime
  void sortByTime() {
    setState(() {
      _filteredRecipes.sort((a, b) {
        final timeA = _parseTotalTime(a.totalTime);
        final timeB = _parseTotalTime(b.totalTime);
        // Urutkan berdasarkan nilai _isDescending: true (terlama ke tercepat), false (tercepat ke terlama)
        return _isDescending ? timeB.compareTo(timeA) : timeA.compareTo(timeB);
      });
      _isSortedByTime = true;
    });
  }

  // Fungsi untuk mengonversi totalTime menjadi durasi dalam menit untuk keperluan sorting
  int _parseTotalTime(String time) {
    final regex = RegExp(r'(\d+)\s*([hm])');
    final matches = regex.allMatches(time.toLowerCase());

    int totalMinutes = 0;
    for (var match in matches) {
      final value = int.tryParse(match.group(1) ?? '0') ?? 0;
      final unit = match.group(2);

      if (unit == 'h') {
        totalMinutes += value * 60;
      } else if (unit == 'm') {
        totalMinutes += value;
      }
    }
    return totalMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Resep Makanan')
          ],
        ),
      ),
      body: Column(
        children: [
          // TextField untuk input pencarian dan tombol filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari resep berdasarkan nama...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      _searchRecipes(value); // Memfilter secara lokal berdasarkan input
                    },
                  ),
                ),
                SizedBox(width: 8),
                // Tombol Filter by Time
                IconButton(
                  icon: Icon(
                    _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDescending = !_isDescending; // Ubah urutan
                      sortByTime(); // Terapkan sort ulang
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        title: _filteredRecipes[index].name,
                        cookTime: _filteredRecipes[index].totalTime,
                        rating: _filteredRecipes[index].rating.toString(),
                        thumbnailUrl: _filteredRecipes[index].images,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

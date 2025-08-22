import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import '../widgets/news_card.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesPage extends StatelessWidget {
  final NewsController controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorited News',
          style: GoogleFonts.lato(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(
            () => controller.favoriteArticles.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () => _showClearAllDialog(),
                  )
                : Container(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.favoriteArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'You have no favorite news yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start adding news to your favorites by tapping the heart icon.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: controller.favoriteArticles.length,
          itemBuilder: (context, index) {
            return NewsCard(
              article: controller.favoriteArticles[index],
              showFavoriteButton: true,
            );
          },
        );
      }),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Delete all Favorite news'),
        content: Text(
          'Are you sure you want to delete all favorite news? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          TextButton(
            onPressed: () {
              controller.favoriteArticles.clear();
              Get.back();
              Get.snackbar(
                'Favorite',
                'All favorite news have been cleared',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

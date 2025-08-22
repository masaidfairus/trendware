import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendware/pages/favorites_page.dart';
import '../controllers/news_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chips.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'theme') {
              themeController.toggleTheme();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'theme',
              child: Row(
                children: [
                  Icon(
                    themeController.isDarkMode.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  SizedBox(width: 8),
                  Text(
                    themeController.isDarkMode.value
                        ? 'Light Mode'
                        : 'Dark Mode',
                  ),
                ],
              ),
            ),
          ],
        ),
        title: Text(
          'TrendWare.',
          style: GoogleFonts.lato(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Get.to(() => SearchPage()),
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Get.to(() => FavoritesPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Chips
          CategoryChips(),

          // News list
          Expanded(
            child: Obx(() {
              if (newsController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading news...'),
                    ],
                  ),
                );
              }

              if (newsController.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          newsController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => newsController.refreshNews(),
                          child: Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (newsController.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text('No news available', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  newsController.refreshNews();
                },
                child: ListView.builder(
                  // padding: EdgeInsets.all(8),
                  itemCount: newsController.articles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: newsController.articles[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

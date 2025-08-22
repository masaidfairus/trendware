import 'package:get/get.dart';
import '../models/article.dart';
import '../models/news_category.dart';
import 'package:trendware/services/news_services.dart';

class NewsController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var articles = <Article>[].obs;
  var favoriteArticles = <Article>[].obs;
  var errorMessage = ''.obs;
  var selectedCategory = 'general'.obs;
  var categories = <NewsCategory>[].obs;
  var searchQuery = ''.obs;
  var isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCategories();
    fetchTopHeadlines();
  }

  void initializeCategories() {
    categories.value = NewsCategory.getAllCategories();
  }

  // Fetch top headlines - menggunakan endpoint yang lebih stabil
  Future<void> fetchTopHeadlines() async {
    try {
      isLoading(true);
      errorMessage('');

      // Coba dulu dengan top headlines US, kalau gagal pakai Indonesian news
      List<Article> result;
      try {
        result = await NewsService.getTopHeadlines(country: 'us');
      } catch (e) {
        print('Top headlines failed, trying Indonesian news: $e');
        result = await NewsService.getIndonesianNews();
      }

      articles.assignAll(result);

      if (result.isEmpty) {
        errorMessage('Tidak ada berita tersedia saat ini');
      }
    } catch (e) {
      errorMessage(
        'Gagal memuat berita: ${e.toString().replaceAll('Exception: ', '')}',
      );
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Fetch news by category - dengan fallback
  Future<void> fetchNewsByCategory(String category) async {
    try {
      isLoading(true);
      errorMessage('');
      selectedCategory(category);

      List<Article> result;
      try {
        result = await NewsService.getNewsByCategory(category);
      } catch (e) {
        print('Category news failed, trying search: $e');
        // Fallback to search dengan kata kunci kategori
        String searchTerm = _getCategorySearchTerm(category);
        result = await NewsService.searchNews(searchTerm);
      }

      articles.assignAll(result);

      if (result.isEmpty) {
        errorMessage('Tidak ada berita untuk kategori $category');
      }
    } catch (e) {
      errorMessage(
        'Gagal memuat berita kategori: ${e.toString().replaceAll('Exception: ', '')}',
      );
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Helper untuk convert category ke search term
  String _getCategorySearchTerm(String category) {
    switch (category) {
      case 'business':
        return 'business finance economy';
      case 'entertainment':
        return 'entertainment celebrity movies';
      case 'health':
        return 'health medical healthcare';
      case 'science':
        return 'science technology research';
      case 'sports':
        return 'sports football basketball';
      case 'technology':
        return 'technology tech innovation';
      default:
        return 'news general';
    }
  }

  // Search news
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      fetchTopHeadlines();
      return;
    }

    try {
      isLoading(true);
      errorMessage('');
      searchQuery(query);

      List<Article> result = await NewsService.searchNews(query);
      articles.assignAll(result);

      if (result.isEmpty) {
        errorMessage('Tidak ada hasil untuk pencarian "$query"');
      }
    } catch (e) {
      errorMessage(
        'Gagal mencari berita: ${e.toString().replaceAll('Exception: ', '')}',
      );
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Toggle favorite
  void toggleFavorite(Article article) {
    if (isFavorite(article)) {
      favoriteArticles.removeWhere((item) => item.url == article.url);
      Get.snackbar(
        'Favorit',
        'Dihapus dari favorit',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } else {
      favoriteArticles.add(article);
      Get.snackbar(
        'Favorit',
        'Ditambahkan ke favorit',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Check if article is favorite
  bool isFavorite(Article article) {
    return favoriteArticles.any((item) => item.url == article.url);
  }

  // Refresh news
  void refreshNews() {
    if (searchQuery.value.isNotEmpty) {
      searchNews(searchQuery.value);
    } else if (selectedCategory.value != 'general') {
      fetchNewsByCategory(selectedCategory.value);
    } else {
      fetchTopHeadlines();
    }
  }

  // Clear search
  void clearSearch() {
    searchQuery('');
    isSearching(false);
    selectedCategory('general');
    fetchTopHeadlines();
  }
}

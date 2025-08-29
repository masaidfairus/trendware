import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/article.dart';

class NewsService {
  // Ganti dengan API Key Anda dari newsapi.org
  static const String apiKey = '0ee0f1145d3d4bdb99b3675225f5da6f';
  static const String baseUrl = 'https://newsapi.org/v2';

  // Proxy URL untuk web (opsional - jika Anda membuat backend proxy)
  static const String proxyUrl = 'https://api.allorigins.win/raw?url=';

  // CORS Proxy alternatives (gunakan salah satu)
  static const String corsProxy1 = 'https://cors-anywhere.herokuapp.com/';
  static const String corsProxy2 = 'https://api.allorigins.win/raw?url=';

  // Helper method untuk mendapatkan URL yang sesuai platform
  static String _getApiUrl(String endpoint) {
    if (kIsWeb) {
      // Untuk web, gunakan CORS proxy
      return '$corsProxy2${Uri.encodeComponent('$baseUrl$endpoint')}';
    } else {
      // Untuk mobile, langsung ke API
      return '$baseUrl$endpoint';
    }
  }

  // Helper method untuk mendapatkan headers yang sesuai platform
  static Map<String, String> _getHeaders() {
    if (kIsWeb) {
      return {
        'Content-Type': 'application/json',
        // Untuk web dengan proxy, kita tidak perlu User-Agent
      };
    } else {
      return {'Content-Type': 'application/json', 'User-Agent': 'NewsApp/1.0'};
    }
  }

  // Method untuk mendapatkan top headlines
  static Future<List<Article>> getTopHeadlines({String country = 'us'}) async {
    try {
      final String endpoint = '/everything?q=technology&apiKey=$apiKey';
      final String url = _getApiUrl(endpoint);

      print('Requesting URL: $url');

      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout. Please check your connection.');
            },
          );

      print('Response status: ${response.statusCode}');
      print(
        'Response body preview: ${response.body.length > 100 ? response.body.substring(0, 100) + "..." : response.body}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if response has error
        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTopHeadlines: $e');
      if (kIsWeb && e.toString().contains('CORS')) {
        throw Exception(
          'CORS Error: Please use a proxy server or enable CORS in development.',
        );
      }
      throw Exception('Network error: $e');
    }
  }

  // Method untuk mendapatkan berita berdasarkan kategori
  static Future<List<Article>> getNewsByCategory(String category) async {
    try {
      // 🔹 Tambahkan pengecekan untuk custom subkategori tech
      final Map<String, String> techSubcategories = {
        "ai":
            "artificial intelligence OR AI OR machine learning OR deep learning",
        "programming":
            "programming OR coding OR software development OR developer",
        "network": "network OR 5G OR cybersecurity OR cloud computing OR cisco OR mikrotik",
        "business_tech": "business technology OR fintech OR digital economy",
        "gadgets": "gadgets OR smartphone OR device OR wearables",
        "apps": "apps OR mobile apps OR application OR software",
        "cloud": "cloud computing OR SaaS OR IaaS OR PaaS",
        "gaming": "gaming OR video games OR e-sports OR gamers OR game",
        "cybersecurity":
            "cybersecurity OR hacking OR data breach OR ransomware",
        "space": "space OR satellite OR nasa OR spacex",
        "automotive": "automotive OR electric vehicles OR EV OR self-driving",
        "green-tech":
            "green technology OR renewable energy OR climate tech OR sustainability",
        "ar-vr": "augmented reality OR virtual reality OR AR OR VR OR metaverse",
        "crypto":
            "cryptocurrency OR blockchain OR bitcoin OR ethereum OR DeFi",
        "robotics": "robotics OR automation OR drones OR industrial robots",
      };

      if (techSubcategories.containsKey(category.toLowerCase())) {
        // Kalau kategori custom → gunakan searchNews()
        return await searchNews(techSubcategories[category.toLowerCase()]!);
      }

      // 🔹 Default: kategori bawaan NewsAPI (business, technology, science, etc.)
      final String endpoint =
          '/everything?q=$category&apiKey=$apiKey';
      final String url = _getApiUrl(endpoint);

      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(Duration(seconds: 30));

      print('Category Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception('Failed to load category news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getNewsByCategory: $e');
      if (kIsWeb && e.toString().contains('CORS')) {
        throw Exception(
          'CORS Error: Please use a proxy server or enable CORS in development.',
        );
      }
      throw Exception('Network error: $e');
    }
  }

  // Method untuk search berita dengan format yang benar
  static Future<List<Article>> searchNews(String query) async {
    try {
      final DateTime thirtyDaysAgo = DateTime.now().subtract(
        Duration(days: 30),
      );
      final String fromDate =
          '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}';

      final String endpoint =
          '/everything?q=${Uri.encodeComponent(query)}&from=$fromDate&sortBy=popularity&language=en&apiKey=$apiKey';
      final String url = _getApiUrl(endpoint);

      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(Duration(seconds: 30));

      print('Search Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .take(20)
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in searchNews: $e');
      if (kIsWeb && e.toString().contains('CORS')) {
        throw Exception(
          'CORS Error: Please use a proxy server or enable CORS in development.',
        );
      }
      throw Exception('Network error: $e');
    }
  }

  // Method untuk mendapatkan berita Indonesia dengan endpoint everything
  static Future<List<Article>> getIndonesianNews() async {
    try {
      final DateTime thirtyDaysAgo = DateTime.now().subtract(
        Duration(days: 30),
      );
      final String fromDate =
          '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}';

      final String endpoint =
          '/everything?q=Indonesia&from=$fromDate&sortBy=popularity&language=en&apiKey=$apiKey';
      final String url = _getApiUrl(endpoint);

      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(Duration(seconds: 30));

      print('Indonesian News Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .take(50)
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception(
          'Failed to load Indonesian news: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getIndonesianNews: $e');
      if (kIsWeb && e.toString().contains('CORS')) {
        throw Exception(
          'CORS Error: Please use a proxy server or enable CORS in development.',
        );
      }
      throw Exception('Network error: $e');
    }
  }

  // Method untuk testing koneksi
  static Future<bool> testConnection() async {
    try {
      final response = await getTopHeadlines();
      return response.isNotEmpty;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}

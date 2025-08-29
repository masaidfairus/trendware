import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../controllers/news_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final Article article;
  final NewsController controller = Get.find<NewsController>();

  DetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: GoogleFonts.lato(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite(article)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavorite(article) ? Colors.red : null,
              ),
              onPressed: () => controller.toggleFavorite(article),
            ),
          ),
          IconButton(icon: Icon(Icons.share), onPressed: () => _shareArticle()),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.urlToImage.isNotEmpty)
              Hero(
                tag: article.url,
                child: SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Image.network(
                    article.urlToImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 14),

                  Text(
                    _formatDate(article.publishedAt),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 14),

                  if (article.author.isNotEmpty &&
                      article.author != 'Unknown Author')
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        children: [
                          Text(
                            article.author,
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Meta info
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Source: ${article.source}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),

                  // Description
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Content (if available)
                  if (article.content.isNotEmpty &&
                      article.content != article.description)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Content:',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w600,
                        //     color:
                        //         Theme.of(context).brightness == Brightness.dark
                        //         ? Colors.white70
                        //         : Colors.black87,
                        //   ),
                        // ),
                        // SizedBox(height: 8),
                        Text(
                          article.content,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  // Read more button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(article.url),
                      icon: Icon(Icons.open_in_browser),
                      label: Text('Read Full Article'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _launchURL(String url) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch the article URL',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _shareArticle() {
    // In a real app, you would use share_plus package
    Get.snackbar(
      'Share',
      'Sharing feature is not implemented in this demo.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

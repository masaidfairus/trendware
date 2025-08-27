import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../pages/detail_page.dart';
import '../models/article.dart';

class ComplicatedCarouselSlider extends StatelessWidget {
  final List<Article> articles; // Ubah dari single article ke list articles

  ComplicatedCarouselSlider({required this.articles});

  @override
  Widget build(BuildContext context) {
    // Ambil maksimal 5 artikel pertama untuk carousel
    final carouselArticles = articles.take(5).toList();

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        height: 200, // Set tinggi tetap untuk carousel
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1.0,
            height: 200,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
          ),
          items: carouselArticles.map((article) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () => Get.to(() => DetailPage(article: article)),
                  child: ClipRRect(
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          article.urlToImage ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
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
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  article.title ?? 'No Title',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (article.source?.isNotEmpty == true)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      article.source ?? 'No Source',
                                      style: GoogleFonts.lato(
                                        color: Colors.white70,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

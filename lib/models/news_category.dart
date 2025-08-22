import 'package:flutter/material.dart';

class NewsCategory {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;

  NewsCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
  });

  static List<NewsCategory> getAllCategories() {
    return [
      NewsCategory(
        id: '0',
        name: '0',
        displayName: 'NEWS',
        icon: Icons.public,
      ),

      NewsCategory(
        id: 'general',
        name: 'general',
        displayName: 'General',
        icon: Icons.public,
      ),
      NewsCategory(
        id: 'business',
        name: 'business',
        displayName: 'Business',
        icon: Icons.business,
      ),
      NewsCategory(
        id: 'entertainment',
        name: 'entertainment',
        displayName: 'Entertainment',
        icon: Icons.movie,
      ),
      NewsCategory(
        id: 'health',
        name: 'health',
        displayName: 'Health',
        icon: Icons.health_and_safety,
      ),
      NewsCategory(
        id: 'science',
        name: 'science',
        displayName: 'Science',
        icon: Icons.science,
      ),
      NewsCategory(
        id: 'sports',
        name: 'sports',
        displayName: 'Sports',
        icon: Icons.sports_soccer,
      ),
      NewsCategory(
        id: 'technology',
        name: 'technology',
        displayName: 'Technology',
        icon: Icons.computer,
      ),
    ];
  }
}

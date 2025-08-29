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
      NewsCategory(id: '0', name: '0', displayName: 'NEWS', icon: Icons.public),
      NewsCategory(
        id: 'technology',
        name: 'technology',
        displayName: 'Technology',
        icon: Icons.computer,
      ),
      NewsCategory(
        id: 'ai',
        name: 'ai',
        displayName: 'AI',
        icon: Icons.smart_toy,
      ),
      NewsCategory(
        id: 'programming',
        name: 'programming',
        displayName: 'Programming',
        icon: Icons.code,
      ),
      NewsCategory(
        id: 'gadgets',
        name: 'gadgets',
        displayName: 'Gadgets',
        icon: Icons.devices,
      ),
      NewsCategory(
        id: 'apps',
        name: 'apps',
        displayName: 'Apps',
        icon: Icons.apps,
      ),
      NewsCategory(
        id: 'cybersecurity',
        name: 'cybersecurity',
        displayName: 'Cybersecurity',
        icon: Icons.security,
      ),
      NewsCategory(
        id: 'cloud',
        name: 'cloud',
        displayName: 'Cloud & Networking',
        icon: Icons.cloud,
      ),
      NewsCategory(
        id: 'business_tech',
        name: 'business_tech',
        displayName: 'Business & Fintech',
        icon: Icons.payments,
      ),
      NewsCategory(
        id: 'gaming',
        name: 'gaming',
        displayName: 'Gaming',
        icon: Icons.sports_esports,
      ),
      NewsCategory(
        id: 'space',
        name: 'space',
        displayName: 'Space Tech',
        icon: Icons.public,
      ),
      NewsCategory(
        id: 'automotive',
        name: 'automotive',
        displayName: 'Automotive',
        icon: Icons.directions_car,
      ),
      NewsCategory(
        id: 'green-tech',
        name: 'green-tech',
        displayName: 'Green Tech',
        icon: Icons.eco,
      ),
      NewsCategory(
        id: 'ar-vr',
        name: 'ar-vr',
        displayName: 'AR/VR & Metaverse',
        icon: Icons.vrpano,
      ),
      NewsCategory(
        id: 'crypto',
        name: 'crypto',
        displayName: 'Blockchain & Crypto',
        icon: Icons.currency_bitcoin,
      ),
      NewsCategory(
        id: 'robotics',
        name: 'robotics',
        displayName: 'Robotics',
        icon: Icons.precision_manufacturing,
      ),
    ];
  }
}

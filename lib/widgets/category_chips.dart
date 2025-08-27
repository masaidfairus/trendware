import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/theme_controller.dart';

class CategoryChips extends StatefulWidget {
  @override
  State createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final NewsController controller = Get.find<NewsController>();
  final ThemeController themeController = Get.find<ThemeController>();
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected =
                controller.selectedCategory.value == category.name;

            if (category.displayName == 'NEWS') {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  right: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'NEWS',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        // color: Color.fromARGB(255, 30, 58, 138),
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : Color.fromARGB(255, 30, 58, 138),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 1,
                      height: 100,
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : Color.fromARGB(255, 30, 58, 138),
                    ),
                    SizedBox(width: 2),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   category.icon,
                    //   size: 16,
                    //   color: isSelected ? Colors.white : Colors.grey[600],
                    // ),
                    // SizedBox(width: 4),
                    Text(
                      category.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onSelected: (selected) {
                  if (selected) {
                    controller.fetchNewsByCategory(category.name);
                  }
                  setState(() {
                    isSelect = selected;
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Color.fromARGB(255, 30, 58, 138),
                checkmarkColor: Colors.white,
                elevation: isSelected ? 3 : 1,
                pressElevation: 2,
              ),
            );
          },
        ),
      ),
    );
  }
}

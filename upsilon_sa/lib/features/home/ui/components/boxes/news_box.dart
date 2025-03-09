// Path: lib/features/home/ui/components/boxes/news_box.dart
import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/boxes/cyber_box.dart';

class NewsBox extends CyberBox {
  final List<Map<String, String>> newsItems;

  const NewsBox({
    Key? key,
    required this.newsItems,
    required double width,
    required double height,
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) : super(
          key: key,
          width: width,
          height: height,
          title: title,
          icon: icon,
          onTap: onTap,
        );

  @override
  Widget buildContent(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView.builder(
      itemCount: newsItems.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final item = newsItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.article,
                    color: primaryColor,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['time'] ?? 'Just now',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: primaryColor,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

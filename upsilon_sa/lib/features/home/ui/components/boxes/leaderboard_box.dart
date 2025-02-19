import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/boxes/cyber_box.dart';

class LeaderboardBox extends CyberBox {
  const LeaderboardBox({
    Key? key,
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
    final topUsers = [
      {'rank': '01', 'name': 'Infinite Money Glitch', 'profit': '+234.5%'},
      {'rank': '02', 'name': 'Quantum β', 'profit': '+187.2%'},
      {'rank': '03', 'name': 'Random System', 'profit': '+156.8%'},
      {'rank': '04', 'name': 'Big Bags', 'profit': '+143.2%'},
      {'rank': '05', 'name': 'Matrix v2.0', 'profit': '+138.7%'},
    ];

    return ListView.builder(
      itemCount: topUsers.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final user = topUsers[index];
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
          child: Row(
            children: [
              Text(
                user['rank']!,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  user['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user['profit']!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:upsilon_sa/core/widgets/custom_navbar.dart';
import 'package:upsilon_sa/features/profile/ui/profile_page.dart';
import 'package:upsilon_sa/features/social/ui/social_page.dart';
import 'package:upsilon_sa/features/systems/ui/systems_page.dart';
import 'package:upsilon_sa/features/news/ui/news_page.dart';
import '../../features/home/ui/home_page.dart';
import '../../features/analytics/ui/analytics_page.dart';

class NavBar {
  late PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const NewsPage(),
      const SystemsPage(),
      const AnalyticsPage(),
      const SocialPage(),
    ];
  }

  Widget build(BuildContext context) {
    return PersistentTabView(
      resizeToAvoidBottomInset: true,
      navBarHeight: 55,
      tabs: [
        PersistentTabConfig(
          screen: const HomePage(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const NewsPage(),
          item: ItemConfig(
            icon: const Icon(Icons.newspaper_outlined),
            title: "News",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const SystemsPage(),
          item: ItemConfig(
            icon: SizedBox(
              width: 28.0, // Ideal size for nav-bar icons
              height: 28.0,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/systems_logo_dark.jpeg'
                    : 'assets/images/systems_logo_light.jpeg',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.settings_outlined, // Fallback icon
                  size: 28.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            title: "Systems",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const SocialPage(),
          item: ItemConfig(
            icon: const Icon(Icons.people_outline_outlined),
            title: "Social",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        PersistentTabConfig(
          screen: const ProfilePage(),
          item: ItemConfig(
            icon: const Icon(Icons.person_3_outlined),
            title: "You",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      avoidBottomPadding: true,
      navBarBuilder: (navBarConfig) => CustomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.zero,
          border: Border(
            top: BorderSide(
              width: 0.38,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

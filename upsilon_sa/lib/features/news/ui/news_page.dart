// Path: lib/features/news/ui/news_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upsilon_sa/features/home/ui/components/webview_page.dart';
import 'package:upsilon_sa/features/news/bloc/news_bloc.dart';
import 'package:upsilon_sa/features/news/ui/components/index.dart';
import 'package:upsilon_sa/core/config/constants.dart';
import 'youtube_video_player.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late NewsBloc newsBloc;
  String currentCategory = 'ALL';

  final List<Map<String, String>> videoItems = [
    {
      'title': 'NEURAL NET: Lakers vs Warriors Analysis',
      'thumbnail': 'https://imageio.forbes.com/specials-images/imageserve/6716c34b8845e0ffb3be4350/Golden-State-Warriors-guard-Stephen-Curry-/0x0.jpg?format=jpg&width=1440',
      'duration': '5m 45s',
      'category': 'NBA',
      'videoUrl': 'https://www.youtube.com/watch?v=9Z6b-jfdJlw'
    },
    {
      'title': 'QUANTUM FORECAST: NFL Week 15',
      'thumbnail': 'https://statico.profootballnetwork.com/wp-content/uploads/2023/10/15174139/fastest-players-nfl-scaled.jpg',
      'duration': '8m 30s',
      'category': 'NFL',
      'videoUrl': 'https://www.youtube.com/watch?v=CRB_OpXxhUA'
    },
  ];

  @override
  void initState() {
    super.initState();
    newsBloc = NewsBloc();
    _tabController = TabController(length: SportCategories.all.length, vsync: this);
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          currentCategory = SportCategories.all[_tabController.index];
        });
        newsBloc.add(NewsLoadedEvent());
      }
    });

    newsBloc.add(NewsLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => newsBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: NewsAppBar(onSearchTap: () => _showSearchModal(context)),
        body: Column(
          children: [
            Container(
              color: Colors.black,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: SportCategories.all.map((category) {
                  return Tab(
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 2,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: SportCategories.all.map((category) {
                  return _buildCategoryContent(category);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent(String category) {
    return RefreshIndicator(
      onRefresh: () async {
        newsBloc.add(NewsLoadedEvent());
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            VideoCarousel(
              videos: _filterVideosByCategory(category),
              onVideoTap: (video) => _onVideoTap(context, video),
            ),
            const SizedBox(height: 16),
            BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoadedState) {
                  final filteredNews = _filterNewsByCategory(state, category);
                  return NewsFeed(
                    news: _mapNewsToList(filteredNews),
                    onNewsTap: (url) => _onNewsCardTap(context, url),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _filterVideosByCategory(String category) {
    if (category == 'ALL') return videoItems;
    return videoItems.where((video) => video['category'] == category).toList();
  }

  Map<String, List<String>> _filterNewsByCategory(NewsState state, String category) {
    if (state is! NewsLoadedState || category == 'ALL') {
      return {
        'titles': state is NewsLoadedState ? state.titles : [],
        'descriptions': state is NewsLoadedState ? state.descriptions : [],
        'imageUrls': state is NewsLoadedState ? state.imageUrls : [],
        'urls': state is NewsLoadedState ? state.urls : [],
      };
    }

    final filteredIndices = state.titles.asMap().entries.where((entry) {
      final title = entry.value.toUpperCase();
      return title.contains(category);
    }).map((e) => e.key).toList();

    return {
      'titles': filteredIndices.map((i) => state.titles[i]).toList(),
      'descriptions': filteredIndices.map((i) => state.descriptions[i]).toList(),
      'imageUrls': filteredIndices.map((i) => state.imageUrls[i]).toList(),
      'urls': filteredIndices.map((i) => state.urls[i]).toList(),
    };
  }

  List<Map<String, String>> _mapNewsToList(Map<String, List<String>> news) {
    final List<Map<String, String>> mappedNews = [];
    for (var i = 0; i < news['titles']!.length; i++) {
      mappedNews.add({
        'title': news['titles']![i],
        'description': news['descriptions']![i],
        'imageUrl': news['imageUrls']![i],
        'url': news['urls']![i],
      });
    }
    return mappedNews;
  }

  void _onVideoTap(BuildContext context, Map<String, String> video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerPage(
          videoUrl: video['videoUrl']!,
        ),
      ),
    );
  }

  void _onNewsCardTap(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewPage(url: url)),
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => const SearchModal(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    newsBloc.close();
    super.dispose();
  }
}
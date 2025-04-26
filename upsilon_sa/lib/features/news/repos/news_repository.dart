import 'dart:async';

class NewsRepository {
  Future<List<Map<String, dynamic>>> getNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'author': 'John Smith',
        'title': 'Lakers Secure Dramatic Overtime Victory Against Celtics',
        'description': 'In a thrilling matchup that went down to the wire, the Los Angeles Lakers emerged victorious over their longtime rivals, the Boston Celtics, in a 124-120 overtime victory that showcased the best of NBA basketball.',
        'url': 'https://example.com/lakers-celtics',
        'urlToImage': 'https://picsum.photos/800/400?random=1',
        'publishedAt': '2024-12-07T18:30:00Z',
        'content': 'Full game recap and analysis...'
      },
      {
        'author': 'Sarah Johnson',
        'title': 'NFL Draft Prospects: Top 5 Quarterbacks to Watch',
        'description': 'As the college football season wraps up, NFL scouts are closely monitoring this year\'s impressive quarterback class. Here\'s an in-depth look at the top prospects who could reshape the league\'s future.',
        'url': 'https://example.com/nfl-draft-qb',
        'urlToImage': 'https://picsum.photos/800/400?random=2',
        'publishedAt': '2024-12-07T16:45:00Z',
        'content': 'Detailed analysis of quarterback prospects...'
      },
      {
        'author': 'Mike Williams',
        'title': 'Warriors Set New Three-Point Record in Dominant Win',
        'description': 'The Golden State Warriors shattered the NBA record for most three-pointers in a single game, connecting on an incredible 30 shots from beyond the arc in their 145-110 victory over the Phoenix Suns.',
        'url': 'https://example.com/warriors-record',
        'urlToImage': 'https://picsum.photos/800/400?random=3',
        'publishedAt': '2024-12-07T14:15:00Z',
        'content': 'Complete game statistics and highlights...'
      },
      {
        'author': 'Emily Brown',
        'title': 'MLB Winter Meetings: Major Trade Shakes Up Division Race',
        'description': 'A blockbuster trade at the MLB Winter Meetings has sent shockwaves through the league as the Yankees acquire an All-Star pitcher in exchange for top prospects, immediately impacting the AL East landscape.',
        'url': 'https://example.com/mlb-trade',
        'urlToImage': 'https://picsum.photos/800/400?random=4',
        'publishedAt': '2024-12-07T12:00:00Z',
        'content': 'Trade details and analysis...'
      },
      {
        'author': 'David Chen',
        'title': 'College Basketball: Unexpected Upset Shakes Up Rankings',
        'description': 'In a stunning turn of events, unranked underdogs defeated the #1 ranked team in college basketball, causing major shifts in the national rankings and March Madness projections.',
        'url': 'https://example.com/college-upset',
        'urlToImage': 'https://picsum.photos/800/400?random=5',
        'publishedAt': '2024-12-07T10:30:00Z',
        'content': 'Game recap and tournament implications...'
      },
      {
        'author': 'Rachel Martinez',
        'title': 'Formula 1: New Technology Breakthrough for Next Season',
        'description': 'Teams are preparing for a revolutionary change in F1 racing as new technological regulations promise to make the sport more competitive and environmentally conscious in the upcoming season.',
        'url': 'https://example.com/f1-tech',
        'urlToImage': 'https://picsum.photos/800/400?random=6',
        'publishedAt': '2024-12-07T09:15:00Z',
        'content': 'Technical analysis and team responses...'
      },
      {
        'author': 'Tom Anderson',
        'title': 'Soccer Transfer News: Record-Breaking Deal Announced',
        'description': 'A Premier League club has broken the transfer record with a stunning €200 million deal for a young superstar, setting new standards in the soccer transfer market and reshaping the competitive landscape.',
        'url': 'https://example.com/soccer-transfer',
        'urlToImage': 'https://picsum.photos/800/400?random=7',
        'publishedAt': '2024-12-07T08:00:00Z',
        'content': 'Transfer details and market analysis...'
      }
    ];
  }

  Future<List<String>> getTitles() async {
    final newsList = await getNews();
    return newsList.map((article) => article['title'] as String).toList();
  }

  Future<List<String>> getUrls() async {
    final newsList = await getNews();
    return newsList.map((article) => article['url'] as String).toList();
  }

  Future<List<String>> getImageUrls() async {
    final newsList = await getNews();
    return newsList.map((article) => article['urlToImage'] as String).toList();
  }

  Future<List<String>> getDescriptions() async {
    final newsList = await getNews();
    return newsList.map((article) => article['description'] as String).toList();
  }
}
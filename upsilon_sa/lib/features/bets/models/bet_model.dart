// lib/features/bets/models/bet_model.dart

class Bet {
  final String id;
  final String sportKey;
  final String sportTitle;
  final DateTime commenceTime;
  final String homeTeam;
  final String awayTeam;
  final List<Bookmaker> bookmakers;

  Bet({
    required this.id,
    required this.sportKey,
    required this.sportTitle,
    required this.commenceTime,
    required this.homeTeam,
    required this.awayTeam,
    required this.bookmakers,
  });

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      id: json['id'],
      sportKey: json['sport_key'],
      sportTitle: json['sport_title'],
      commenceTime: DateTime.parse(json['commence_time']),
      homeTeam: json['home_team'],
      awayTeam: json['away_team'],
      bookmakers: (json['bookmakers'] as List)
          .map((bookmaker) => Bookmaker.fromJson(bookmaker))
          .toList(),
    );
  }

  // Helper method to get the best moneyline (h2h) odds for each team
  Map<String, dynamic> getBestMoneylineOdds() {
    double? bestHomeOdds;
    double? bestAwayOdds;
    String? homeBookmaker;
    String? awayBookmaker;

    for (final bookmaker in bookmakers) {
      final h2hMarket = bookmaker.markets.firstWhere(
        (market) => market.key == 'h2h',
        orElse: () => Market(key: '', lastUpdate: DateTime.now(), outcomes: []),
      );

      if (h2hMarket.outcomes.isEmpty) continue;

      for (final outcome in h2hMarket.outcomes) {
        if (outcome.name == homeTeam) {
          if (bestHomeOdds == null || outcome.price > bestHomeOdds) {
            bestHomeOdds = outcome.price.toDouble();
            homeBookmaker = bookmaker.title;
          }
        } else if (outcome.name == awayTeam) {
          if (bestAwayOdds == null || outcome.price > bestAwayOdds) {
            bestAwayOdds = outcome.price.toDouble();
            awayBookmaker = bookmaker.title;
          }
        }
      }
    }

    return {
      'home': {
        'odds': bestHomeOdds,
        'bookmaker': homeBookmaker,
      },
      'away': {
        'odds': bestAwayOdds,
        'bookmaker': awayBookmaker,
      },
    };
  }

  // Helper method to get the best spread odds for each team
  Map<String, dynamic> getBestSpreadOdds() {
    double? bestHomeOdds;
    double? bestAwayOdds;
    double? homePoint;
    double? awayPoint;
    String? homeBookmaker;
    String? awayBookmaker;

    for (final bookmaker in bookmakers) {
      final spreadMarket = bookmaker.markets.firstWhere(
        (market) => market.key == 'spreads',
        orElse: () => Market(key: '', lastUpdate: DateTime.now(), outcomes: []),
      );

      if (spreadMarket.outcomes.isEmpty) continue;

      for (final outcome in spreadMarket.outcomes) {
        if (outcome.name == homeTeam) {
          if (bestHomeOdds == null || outcome.price > bestHomeOdds) {
            bestHomeOdds = outcome.price.toDouble();
            homePoint = outcome.point;
            homeBookmaker = bookmaker.title;
          }
        } else if (outcome.name == awayTeam) {
          if (bestAwayOdds == null || outcome.price > bestAwayOdds) {
            bestAwayOdds = outcome.price.toDouble();
            awayPoint = outcome.point;
            awayBookmaker = bookmaker.title;
          }
        }
      }
    }

    return {
      'home': {
        'odds': bestHomeOdds,
        'point': homePoint,
        'bookmaker': homeBookmaker,
      },
      'away': {
        'odds': bestAwayOdds,
        'point': awayPoint,
        'bookmaker': awayBookmaker,
      },
    };
  }

  // Helper method to get the best totals (over/under) odds
  Map<String, dynamic> getBestTotalsOdds() {
    double? bestOverOdds;
    double? bestUnderOdds;
    double? overPoint;
    double? underPoint;
    String? overBookmaker;
    String? underBookmaker;

    for (final bookmaker in bookmakers) {
      final totalsMarket = bookmaker.markets.firstWhere(
        (market) => market.key == 'totals',
        orElse: () => Market(key: '', lastUpdate: DateTime.now(), outcomes: []),
      );

      if (totalsMarket.outcomes.isEmpty) continue;

      for (final outcome in totalsMarket.outcomes) {
        if (outcome.name == 'Over') {
          if (bestOverOdds == null || outcome.price > bestOverOdds) {
            bestOverOdds = outcome.price.toDouble();
            overPoint = outcome.point;
            overBookmaker = bookmaker.title;
          }
        } else if (outcome.name == 'Under') {
          if (bestUnderOdds == null || outcome.price > bestUnderOdds) {
            bestUnderOdds = outcome.price.toDouble();
            underPoint = outcome.point;
            underBookmaker = bookmaker.title;
          }
        }
      }
    }

    return {
      'over': {
        'odds': bestOverOdds,
        'point': overPoint,
        'bookmaker': overBookmaker,
      },
      'under': {
        'odds': bestUnderOdds,
        'point': underPoint,
        'bookmaker': underBookmaker,
      },
    };
  }
}

class Bookmaker {
  final String key;
  final String title;
  final DateTime lastUpdate;
  final List<Market> markets;

  Bookmaker({
    required this.key,
    required this.title,
    required this.lastUpdate,
    required this.markets,
  });

  factory Bookmaker.fromJson(Map<String, dynamic> json) {
    return Bookmaker(
      key: json['key'],
      title: json['title'],
      lastUpdate: DateTime.parse(json['last_update']),
      markets: (json['markets'] as List)
          .map((market) => Market.fromJson(market))
          .toList(),
    );
  }
}

class Market {
  final String key;
  final DateTime lastUpdate;
  final List<Outcome> outcomes;

  Market({
    required this.key,
    required this.lastUpdate,
    required this.outcomes,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      key: json['key'],
      lastUpdate: DateTime.parse(json['last_update']),
      outcomes: (json['outcomes'] as List)
          .map((outcome) => Outcome.fromJson(outcome))
          .toList(),
    );
  }
}

class Outcome {
  final String name;
  final int price;
  final double? point;

  Outcome({
    required this.name,
    required this.price,
    this.point,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      name: json['name'],
      price: json['price'],
      point: json['point'] != null ? json['point'].toDouble() : null,
    );
  }
}
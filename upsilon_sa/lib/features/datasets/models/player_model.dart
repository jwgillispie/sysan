class Player {
  final String name;
  final int age;
  final int experience;
  final String position; // Assuming Positions is represented as a String
  // final Map<int, Map<String, double>> seasonStatistics;

  Player({
    required this.name,
    required this.age,
    required this.experience,
    required this.position,
    // required this.seasonStatistics,
  });

  // Method to deserialize from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      age: json['age'],
      experience: json['experience'],
      position: json['position'],
      // seasonStatistics: Map<int, Map<String, double>>.from(
      //   (json['season_statistics'] as Map).map(
      //     (key, value) => MapEntry(
      //       int.parse(key),
      //       Map<String, double>.from(value),
      //     ),
      //   ),
      // ),
    );
  }

  // Method to serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'experience': experience,
      'position': position
      // 'season_statistics': seasonStatistics.map(
      //   (key, value) => MapEntry(
      //     key.toString(),
      //     value.map((statKey, statValue) => MapEntry(statKey, statValue)),
      //   ),
      // ),
    };
  }
}

// lib/features/systems_creation/models/factor_model.dart

class Factor {
  final int id;
  String name;
  double weight;
  bool expanded;
  int threshold;
  int gamesBack;

  Factor({
    required this.id,
    required this.name,
    this.weight = 50.0,
    this.expanded = false,
    this.threshold = 20,
    this.gamesBack = 5,
  });

  Factor copyWith({
    String? name,
    double? weight,
    bool? expanded,
    int? threshold,
    int? gamesBack,
  }) {
    return Factor(
      id: this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      expanded: expanded ?? this.expanded,
      threshold: threshold ?? this.threshold,
      gamesBack: gamesBack ?? this.gamesBack,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'threshold': threshold,
      'gamesBack': gamesBack,
    };
  }

  factory Factor.fromJson(Map<String, dynamic> json) {
    return Factor(
      id: json['id'],
      name: json['name'],
      weight: json['weight'] ?? 50.0,
      threshold: json['threshold'] ?? 20,
      gamesBack: json['gamesBack'] ?? 5,
    );
  }
}
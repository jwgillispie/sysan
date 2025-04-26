// lib/features/systems_creation/models/factor_model.dart
class Factor {
  final int id;
  final String name;
  final String category;
  final String unit; // Add this field
  final bool expanded;
  final double weight;
  final int threshold;
  final int gamesBack;
  final bool isAboveThreshold; // Default to above

  const Factor({
    required this.id,
    required this.name,
    this.category = 'Uncategorized',
    this.unit = '', // Default empty unit
    this.expanded = false,
    this.weight = 50.0,
    this.threshold = 5,
    this.gamesBack = 10,
    this.isAboveThreshold = true
  });

  Factor copyWith({
    int? id,
    String? name,
    String? category,
    String? unit,
    bool? expanded,
    double? weight,
    int? threshold,
    int? gamesBack,
    bool? isAboveThreshold,
  }) {
    return Factor(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      expanded: expanded ?? this.expanded,
      weight: weight ?? this.weight,
      threshold: threshold ?? this.threshold,
      gamesBack: gamesBack ?? this.gamesBack,
      isAboveThreshold: isAboveThreshold ?? this.isAboveThreshold
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
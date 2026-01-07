class CarModelModel {
  final int id;
  final String name;

  const CarModelModel({
    required this.id,
    required this.name,
  });

  factory CarModelModel.fromJson(Map<String, dynamic> json) {
    return CarModelModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

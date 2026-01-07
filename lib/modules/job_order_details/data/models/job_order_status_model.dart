class JobOrderStatusModel {
  final int id;
  final String name;
  final String? icon;
  final String? color;
  final int? sortOrder;

  const JobOrderStatusModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.sortOrder,
  });

  factory JobOrderStatusModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return JobOrderStatusModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      color: json['color']?.toString(),
      sortOrder: json['sort_order'] is int
          ? json['sort_order'] as int
          : int.tryParse(json['sort_order']?.toString() ?? ''),
    );
  }
}

import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.name,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return ServiceModel(
      id: id is int ? id : int.tryParse(id?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

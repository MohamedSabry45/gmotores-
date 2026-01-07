import '../../domain/entities/branch.dart';

class BranchModel extends Branch {
  const BranchModel({
    required super.id,
    required super.name,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return BranchModel(
      id: id is int ? id : int.tryParse(id?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

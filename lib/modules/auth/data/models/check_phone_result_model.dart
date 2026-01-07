import '../../domain/entities/check_phone_result.dart';

class CheckPhoneResultModel extends CheckPhoneResult {
  const CheckPhoneResultModel({
    required super.userFound,
    required super.result,
    required super.code,
    required super.name,
  });

  factory CheckPhoneResultModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    final result = data['result']?.toString() ?? '';
    final code = data['code']?.toString() ?? '';
    final name = data['name']?.toString() ?? '';

    final normalized = result.toLowerCase();
    final userFound = normalized.contains('found') && !normalized.contains('not');

    return CheckPhoneResultModel(
      userFound: userFound,
      result: result,
      code: code,
      name: name,
    );
  }
}

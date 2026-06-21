class SocialAuthResponseModel {
  final bool success;
  final bool phoneExist;
  final bool isNewUser;
  final bool isSoftDeleted;
  final int? userId;
  final String action;
  final String token;
  final String message;
  final SocialAuthUserModel? user;

  const SocialAuthResponseModel({
    required this.success,
    required this.phoneExist,
    required this.isNewUser,
    required this.isSoftDeleted,
    required this.userId,
    required this.action,
    required this.token,
    required this.message,
    required this.user,
  });

  factory SocialAuthResponseModel.fromJson(Map<String, dynamic> json) {
    final success = json['success'] == true || json['success']?.toString() == 'true';
    final phoneExist = json['phone_exist'] == true || json['phone_exist']?.toString() == 'true';
    final isNewUser = json['is_new_user'] == true || json['is_new_user']?.toString() == 'true';
    final isSoftDeleted = json['is_soft_deleted'] == true || json['is_soft_deleted']?.toString() == 'true';
    final userId = int.tryParse(json['user_id']?.toString() ?? '');
    final action = json['action']?.toString() ?? '';
    final token = json['token']?.toString() ?? '';
    final message = json['message']?.toString() ?? '';

    final userJson = json['user'];
    return SocialAuthResponseModel(
      success: success,
      phoneExist: phoneExist,
      isNewUser: isNewUser,
      isSoftDeleted: isSoftDeleted,
      userId: userId,
      action: action,
      token: token,
      message: message,
      user: userJson is Map<String, dynamic> ? SocialAuthUserModel.fromJson(userJson) : null,
    );
  }
}

class SocialAuthUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  const SocialAuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory SocialAuthUserModel.fromJson(Map<String, dynamic> json) {
    return SocialAuthUserModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['mobile']?.toString() ?? '',
    );
  }
}

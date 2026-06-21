abstract class SocialAuthState {}

class SocialAuthRestoreRequired extends SocialAuthState {
  final int userId;
  final String message;

  SocialAuthRestoreRequired({
    required this.userId,
    required this.message,
  });
}

class SocialAuthInitial extends SocialAuthState {}

class SocialAuthLoading extends SocialAuthState {}

class SocialAuthNeedPhone extends SocialAuthState {
  final String email;
  final String name;
  final String medium;
  final String uniqueId;
  final int? userId;

  SocialAuthNeedPhone({
    required this.email,
    required this.name,
    required this.medium,
    required this.uniqueId,
    required this.userId,
  });
}

class SocialAuthSendPhoneOtpSuccess extends SocialAuthState {
  final String phone;
  final String email;
  final int expiresInMinutes;

  SocialAuthSendPhoneOtpSuccess({
    required this.phone,
    required this.email,
    required this.expiresInMinutes,
  });
}

class SocialAuthSuccess extends SocialAuthState {
  final String token;

  SocialAuthSuccess(this.token);
}

class SocialAuthError extends SocialAuthState {
  final String message;

  SocialAuthError(this.message);
}

class SocialAuthOwnershipRequired extends SocialAuthState {
  final int existingUserId;
  final String phone;
  final String message;
  final Map<String, dynamic> existingUser;
  final Map<String, dynamic> pendingSocialUser;

  SocialAuthOwnershipRequired({
    required this.existingUserId,
    required this.phone,
    required this.message,
    required this.existingUser,
    required this.pendingSocialUser,
  });
}

class SocialAuthOwnershipOtpSent extends SocialAuthState {
  final int existingUserId;
  final String phone;
  final String email;
  final String name;
  final String medium;
  final String uniqueId;

  SocialAuthOwnershipOtpSent({
    required this.existingUserId,
    required this.phone,
    required this.email,
    required this.name,
    required this.medium,
    required this.uniqueId,
  });
}

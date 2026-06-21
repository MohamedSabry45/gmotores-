class CheckPhoneResult {
  final bool userFound;
  final String result;
  final String code;
  final String name;
  final bool isSoftDeleted;
  final int? userId;
  final String message;

  const CheckPhoneResult({
    required this.userFound,
    required this.result,
    required this.code,
    required this.name,
    this.isSoftDeleted = false,
    this.userId,
    this.message = '',
  });
}

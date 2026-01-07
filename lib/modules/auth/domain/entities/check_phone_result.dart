class CheckPhoneResult {
  final bool userFound;
  final String result;
  final String code;
  final String name;

  const CheckPhoneResult({
    required this.userFound,
    required this.result,
    required this.code,
    required this.name,
  });
}

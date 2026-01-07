class LoyaltyPointsModel {
  final bool success;
  final LoyaltyPointsData data;

  const LoyaltyPointsModel({
    required this.success,
    required this.data,
  });

  factory LoyaltyPointsModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyPointsModel(
      success: json['success'] == true,
      data: LoyaltyPointsData.fromJson(
        (json['data'] is Map<String, dynamic>) ? (json['data'] as Map<String, dynamic>) : <String, dynamic>{},
      ),
    );
  }
}

class LoyaltyPointsData {
  final int totalPoints;
  final int redeemablePoints;
  final double redeemableAmount;
  final int pointsUsed;
  final int pointsExpired;
  final bool enableRp;
  final String? rpName;
  final int? minRedeemPoint;
  final int? maxRedeemPoint;
  final String amountPerPoint;
  final String minOrderTotalForRedeem;

  const LoyaltyPointsData({
    required this.totalPoints,
    required this.redeemablePoints,
    required this.redeemableAmount,
    required this.pointsUsed,
    required this.pointsExpired,
    required this.enableRp,
    required this.rpName,
    required this.minRedeemPoint,
    required this.maxRedeemPoint,
    required this.amountPerPoint,
    required this.minOrderTotalForRedeem,
  });

  factory LoyaltyPointsData.fromJson(Map<String, dynamic> json) {
    return LoyaltyPointsData(
      totalPoints: _asInt(json['total_points']),
      redeemablePoints: _asInt(json['redeemable_points']),
      redeemableAmount: _asDouble(json['redeemable_amount']),
      pointsUsed: _asInt(json['points_used']),
      pointsExpired: _asInt(json['points_expired']),
      enableRp: json['enable_rp'] == true,
      rpName: json['rp_name']?.toString(),
      minRedeemPoint: _asNullableInt(json['min_redeem_point']),
      maxRedeemPoint: _asNullableInt(json['max_redeem_point']),
      amountPerPoint: json['amount_per_point']?.toString() ?? '',
      minOrderTotalForRedeem: json['min_order_total_for_redeem']?.toString() ?? '',
    );
  }

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static int? _asNullableInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString());
  }

  static double _asDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}

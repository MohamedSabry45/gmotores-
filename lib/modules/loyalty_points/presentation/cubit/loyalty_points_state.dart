import '../../data/models/loyalty_points_model.dart';

abstract class LoyaltyPointsState {}

class LoyaltyPointsInitial extends LoyaltyPointsState {}

class LoyaltyPointsLoading extends LoyaltyPointsState {}

class LoyaltyPointsSuccess extends LoyaltyPointsState {
  final LoyaltyPointsData data;

  LoyaltyPointsSuccess(this.data);
}

class LoyaltyPointsRedeemLoading extends LoyaltyPointsState {
  final LoyaltyPointsData data;

  LoyaltyPointsRedeemLoading(this.data);
}

class LoyaltyPointsError extends LoyaltyPointsState {
  final String message;

  LoyaltyPointsError(this.message);
}

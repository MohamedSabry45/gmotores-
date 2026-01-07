import '../../../domain/entities/branch.dart';

abstract class BranchState {}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchSuccess extends BranchState {
  final List<Branch> branches;

  BranchSuccess(this.branches);
}

class BranchError extends BranchState {
  final String message;

  BranchError(this.message);
}

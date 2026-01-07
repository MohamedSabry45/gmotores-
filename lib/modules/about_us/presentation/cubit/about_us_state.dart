import '../../data/models/about_us_model.dart';

abstract class AboutUsState {}

class AboutUsInitial extends AboutUsState {}

class AboutUsLoading extends AboutUsState {}

class AboutUsSuccess extends AboutUsState {
  final AboutUsModel data;

  AboutUsSuccess(this.data);
}

class AboutUsError extends AboutUsState {
  final String message;

  AboutUsError(this.message);
}

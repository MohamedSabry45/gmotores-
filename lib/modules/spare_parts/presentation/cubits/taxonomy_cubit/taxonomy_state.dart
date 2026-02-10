import '../../../domain/entities/taxonomy_category.dart';

abstract class TaxonomyState {}

class TaxonomyInitial extends TaxonomyState {}

class TaxonomyLoading extends TaxonomyState {}

class TaxonomySuccess extends TaxonomyState {
  final List<TaxonomyCategory> categories;

  TaxonomySuccess(this.categories);
}

class TaxonomyError extends TaxonomyState {
  final String message;

  TaxonomyError(this.message);
}

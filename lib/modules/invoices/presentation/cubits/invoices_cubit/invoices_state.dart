import '../../../data/models/sell_invoice_model.dart';

abstract class InvoicesState {}

class InvoicesInitial extends InvoicesState {}

class InvoicesLoading extends InvoicesState {}

class InvoicesSuccess extends InvoicesState {
  final List<SellInvoiceModel> invoices;

  InvoicesSuccess(this.invoices);
}

class InvoicesError extends InvoicesState {
  final String message;

  InvoicesError(this.message);
}

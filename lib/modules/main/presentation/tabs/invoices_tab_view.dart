import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/core/widgets/login_required_view.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/invoices/presentation/cubits/invoices_cubit/invoices_cubit.dart';
import 'package:reservation_workshop/modules/invoices/presentation/cubits/invoices_cubit/invoices_state.dart';
import 'package:reservation_workshop/modules/invoices/presentation/screens/invoice_details_args.dart';
import 'package:reservation_workshop/modules/invoices/presentation/widgets/invoice_card_widget.dart';

class InvoicesTabView extends StatelessWidget {
  const InvoicesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoicesCubit>(
      create: (_) => InvoicesCubit(),
      child: const _InvoicesTabBody(),
    );
  }
}

class _InvoicesTabBody extends StatefulWidget {
  const _InvoicesTabBody();

  @override
  State<_InvoicesTabBody> createState() => _InvoicesTabBodyState();
}

class _InvoicesTabBodyState extends State<_InvoicesTabBody> {
  int? _lastLoadedContactId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final customerState = context.read<CustomerInfoCubit>().state;
    if (customerState is CustomerInfoSuccess) {
      final id = customerState.info.id;
      if (id > 0 && id != _lastLoadedContactId) {
        _lastLoadedContactId = id;
        context.read<InvoicesCubit>().load(contactId: id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
      builder: (context, customerState) {
        final contactId = customerState is CustomerInfoSuccess ? customerState.info.id : 0;

        if (contactId == 0) {
          return const LoginRequiredView();
        }

        if (customerState is CustomerInfoLoading || contactId == 0) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return BlocBuilder<InvoicesCubit, InvoicesState>(
          builder: (context, state) {
            if (state is InvoicesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is InvoicesError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<InvoicesCubit>().load(contactId: contactId);
                          },
                          child: Text('Retry'.tr()),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is InvoicesSuccess) {
              if (state.invoices.isEmpty) {
                return Center(
                  child: AppCard(
                    child: Text(
                      'No invoices'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<InvoicesCubit>().load(contactId: contactId),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                  itemBuilder: (context, index) {
                    final invoice = state.invoices[index];
                    return InvoiceCardWidget(
                      invoice: invoice,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.invoiceDetailsScreen,
                          arguments: InvoiceDetailsArgs(invoice: invoice),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemCount: state.invoices.length,
                ),
              );
            }

            return Center(
              child: Text(
                'tabs.invoice'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

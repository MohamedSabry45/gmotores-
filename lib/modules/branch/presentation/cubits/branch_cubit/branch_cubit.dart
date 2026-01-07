import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/branch_remote_datasource.dart';
import 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit() : super(BranchInitial());

  static BranchCubit get(context) => BlocProvider.of<BranchCubit>(context);

  late final BranchRemoteDataSource _remote = BranchRemoteDataSource();

  Future<void> load() async {
    emit(BranchLoading());
    try {
      final branches = await _remote.getBranches();
      emit(BranchSuccess(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }
}

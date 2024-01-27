import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_final_assignment/features/bidding/domain/use_case/bid_use_case.dart';
import 'package:flutter_final_assignment/features/bidding/presentation/state/bid_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// dependency injection using riverpod
final bidViewModelProvider =
    StateNotifierProvider.autoDispose<BidViewModel, BidState>((ref) {
  return BidViewModel(
    ref.watch(bidUsecaseProvider),
  );
});

class BidViewModel extends StateNotifier<BidState> {
  final BidUseCase bidUseCase;

  BidViewModel(this.bidUseCase) : super(BidState.initial());

  bidOnArt(BidEntity bid, String artId) async {
    state = state.copyWith(isLoading: true);
    var data = await bidUseCase.bidOnArt(bid, artId);
    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }

  getAllBids() async {
    state = state.copyWith(isLoading: true);
    var data = await bidUseCase.getAllBids();
    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, bids: r, error: null),
    );
  }

  getBid(String bidId) async {
    state = state.copyWith(isLoading: true);
    var data = await bidUseCase.getBid(bidId);
    state = state.copyWith(bidById: []);


    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, bidById: r, error: null),
    );
  }
}

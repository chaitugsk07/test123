part of 'get4_outlets_bloc.dart';

class Get4OutletsState extends Equatable {
  final List<SynopseArticlesVGet4Outlet> synopseArticlesVGet4Outlet;
  final bool hasReachedMax;
  final Get4OutletssStatus status;

  const Get4OutletsState(
      {this.synopseArticlesVGet4Outlet = const <SynopseArticlesVGet4Outlet>[],
      this.hasReachedMax = false,
      this.status = Get4OutletssStatus.initial});

  Get4OutletsState copyWith({
    List<SynopseArticlesVGet4Outlet>? synopseArticlesVGet4Outlet,
    bool? hasReachedMax,
    Get4OutletssStatus? status,
  }) {
    return Get4OutletsState(
      synopseArticlesVGet4Outlet:
          synopseArticlesVGet4Outlet ?? this.synopseArticlesVGet4Outlet,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseArticlesVGet4Outlet, hasReachedMax, status];
}

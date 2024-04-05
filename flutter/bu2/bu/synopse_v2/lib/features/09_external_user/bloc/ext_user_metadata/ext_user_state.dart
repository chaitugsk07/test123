part of 'ext_user_bloc.dart';

class ExtUserState extends Equatable {
  final List<SynopseRealtimeVUserMetadatum> synopseRealtimeVUserMetadatum;
  final bool hasReachedMax;
  final ExtUserStatus status;

  const ExtUserState(
      {this.synopseRealtimeVUserMetadatum =
          const <SynopseRealtimeVUserMetadatum>[],
      this.hasReachedMax = false,
      this.status = ExtUserStatus.initial});

  ExtUserState copyWith({
    List<SynopseRealtimeVUserMetadatum>? synopseRealtimeVUserMetadatum,
    bool? hasReachedMax,
    ExtUserStatus? status,
  }) {
    return ExtUserState(
      synopseRealtimeVUserMetadatum:
          synopseRealtimeVUserMetadatum ?? this.synopseRealtimeVUserMetadatum,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [synopseRealtimeVUserMetadatum, hasReachedMax, status];
}

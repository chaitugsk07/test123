part of 'onBoarding_bloc.dart';

@immutable
abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();
  @override
  List<Object?> get props => [];
}

class GetOnBoardingFetch extends OnBoardingEvent {}

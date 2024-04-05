part of 'onBoarding_bloc.dart';

class OnBoardingState extends Equatable {
  final List<Onboarding> onboarding;
  final OnBoardingStatus status;

  const OnBoardingState(
      {this.onboarding = const <Onboarding>[],
      this.status = OnBoardingStatus.initial});

  OnBoardingState copyWith({
    List<Onboarding>? onboarding,
    OnBoardingStatus? status,
  }) {
    return OnBoardingState(
      onboarding: onboarding ?? this.onboarding,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [onboarding, status];
}

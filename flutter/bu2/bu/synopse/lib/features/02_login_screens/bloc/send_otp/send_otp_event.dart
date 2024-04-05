part of 'send_otp_bloc.dart';

@immutable
abstract class SendOTPEvent extends Equatable {
  const SendOTPEvent();
  @override
  List<Object?> get props => [];
}

class SendOTPForValidPhNo extends SendOTPEvent {
  final String country;
  final String phoneno;

  const SendOTPForValidPhNo({required this.country, required this.phoneno});

  @override
  List<Object> get props => [country, phoneno];
}

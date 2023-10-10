part of 'send_otp_bloc.dart';

@immutable
abstract class SendOTPEvent extends Equatable {
  const SendOTPEvent();
  @override
  List<Object?> get props => [];
}

class SendOTPForValidPhNo extends SendOTPEvent {
  final int phoneNumber;

  const SendOTPForValidPhNo({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

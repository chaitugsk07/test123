part of 'verifiy_otp_bloc.dart';

@immutable
abstract class VerifyOTPEvent extends Equatable {
  const VerifyOTPEvent();
  @override
  List<Object?> get props => [];
}

class VerifyOTPForValidPhNo extends VerifyOTPEvent {
  final int phoneNumber;
  final int otp;

  const VerifyOTPForValidPhNo({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object> get props => [phoneNumber, otp];
}

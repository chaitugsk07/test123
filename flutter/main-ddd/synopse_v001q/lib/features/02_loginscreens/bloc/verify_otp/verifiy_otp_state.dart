part of 'verifiy_otp_bloc.dart';

class VerifyOTPState extends Equatable {
  final VerifyOTPStatus status;

  const VerifyOTPState({required this.status});

  VerifyOTPState copyWith({VerifyOTPStatus? status}) {
    return VerifyOTPState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

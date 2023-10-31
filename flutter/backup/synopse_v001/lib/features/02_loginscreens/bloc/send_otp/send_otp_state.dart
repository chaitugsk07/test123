part of 'send_otp_bloc.dart';

class SendOTPState extends Equatable {
  final SendOTPStatus status;

  const SendOTPState({required this.status});

  SendOTPState copyWith({SendOTPStatus? status}) {
    return SendOTPState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
